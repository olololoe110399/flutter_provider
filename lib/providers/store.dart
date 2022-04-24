import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
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
  User? _user;
  // public
  String error = '';
  bool loading = false;

  List<User> get users => _users;
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

  void getUsers() {
    loading = true;
    _apiService
        .getUsers()
        .then(_handleGetUser)
        .catchError(_handleError)
        .whenComplete(_handleComplete);
  }

  void getUserDetail(int id) {
    loading = true;
    _apiService
        .getUserDetail(id)
        .then(_handleGetUserDetail)
        .catchError(_handleError)
        .whenComplete(_handleComplete);
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
