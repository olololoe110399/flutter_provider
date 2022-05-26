import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider_sample/local/sql_hepler.dart';
import 'package:provider_sample/models/item.dart';
import 'package:provider_sample/models/user.dart';
import 'package:provider_sample/network/api_service.dart';

import 'package:dio/dio.dart';

final logger = Logger();

class Store extends ChangeNotifier {
  Store() {
    _apiService = ApiService(Dio());
  }
  // private
  late ApiService _apiService;
  List<User> _users = [];
  List<Item> _items = [];
  User? _user;
  bool _isFavorite = false;
  // public
  String error = '';
  bool loading = false;
  bool get isFavorite => _isFavorite;

  List<User> get users => _users;
  List<Item> get items => _items;

  set items(List<Item> newItems) {
    _items = newItems;
    notifyListeners();
  }

  set users(List<User> newUsers) {
    _users = newUsers;
    notifyListeners();
  }

  User? get user => _user;
  set user(User? newUser) {
    _user = newUser;
    notifyListeners();
  }

  Future<void> onRefresh() async {
    getUsers();
  }

  Future<void> onRefreshFavorite() async {
    getFavorites();
  }

  void getFavorites() {
    loading = true;
    SQLHelper.getItems()
        .then(_handleGetFavorite)
        .catchError(_handleError)
        .whenComplete(_handleComplete);
  }

  void getUsers() {
    loading = true;
    _apiService
        .getUsers()
        .then(_handleGetUser)
        .catchError(_handleError)
        .whenComplete(_handleComplete);
  }

  void getUserDetail(int id) async {
    loading = true;
    user = null;
    _updateFavorite(id);
    _apiService
        .getUserDetail(id)
        .then(_handleGetUserDetail)
        .catchError(_handleError)
        .whenComplete(_handleComplete);
  }

  toggleFavorite() async {
    if (_user != null) {
      final item = await SQLHelper.getItem(user!.id!);
      if (item == null) {
        await SQLHelper.createItem(
          user!.id!,
          user!.name!,
          user!.email!,
        );
      } else {
        await SQLHelper.deleteItem(user!.id!);
      }
      _updateFavorite(user!.id!);
      getFavorites();
    }
  }

  _updateFavorite(int id) async {
    await SQLHelper.getItem(id).then((value) {
      if (value != null) {
        _isFavorite = true;
        notifyListeners();
      } else {
        _isFavorite = false;
        notifyListeners();
      }
    }).catchError((err) {
      _isFavorite = false;
      notifyListeners();
    });
  }

  _handleGetUser(List<User> value) {
    final prettyString = const JsonEncoder.withIndent('  ').convert(
      jsonDecode(
        jsonEncode(value),
      ),
    );
    logger.d(prettyString);
    users = value;
  }

  _handleGetFavorite(List<Item> value) {
    final prettyString = const JsonEncoder.withIndent('  ').convert(
      jsonDecode(
        jsonEncode(value),
      ),
    );
    logger.d(prettyString);
    items = value;
  }

  _handleGetUserDetail(User value) {
    logger.d(value.toJson());
    user = value;
  }

  _handleComplete() {
    notifyListeners();
    loading = false;
  }

  // ignore: prefer_void_to_null
  FutureOr<Null> _handleError(Object? error) async {
    logger.e(error);
    loading = false;
    this.error = error.toString();
    notifyListeners();
    return null;
  }
}
