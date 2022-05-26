import 'package:flutter/material.dart';
import 'package:provider_sample/models/item.dart';
import 'package:sqflite/sqflite.dart' as sql;

class AppSQL {
  const AppSQL._();
  static const nameDb = 'manga_app.db';
  static const itemsTable = 'items';
  static const createItemsTable =
      'CREATE TABLE items (id INTEGER PRIMARY KEY NOT NULL, name TEXT, email TEXT, create_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)';
}

class SQLHelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      AppSQL.nameDb,
      version: 1,
      onCreate: (db, version) async {
        await createItemTables(db);
      },
    );
  }

  static Future<void> createItemTables(sql.Database database) async {
    await database.execute(AppSQL.createItemsTable);
  }

  static Future<int> createItem(int id, String name, String email) async {
    final db = await SQLHelper.db();

    final newsId = await db.insert(
      AppSQL.itemsTable,
      {
        'id': id,
        'name': name,
        'email': email,
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    return newsId;
  }

  static Future<List<Item>> getItems() async {
    final db = await SQLHelper.db();
    final listItems = await db.query(AppSQL.itemsTable);
    return listItems.map((e) => Item.fromJson(e)).toList();
  }

  static Future<Item?> getItem(int id) async {
    final db = await SQLHelper.db();
    final listItems =
        await db.query(AppSQL.itemsTable, where: 'id=?', whereArgs: [id]);

    return listItems.isNotEmpty ? Item.fromJson(listItems.first) : null;
  }

  static Future<int> updateItem(Item item) async {
    final db = await SQLHelper.db();
    final result = await db.update(
        AppSQL.itemsTable,
        {
          'name': item.name,
        },
        where: 'id=?',
        whereArgs: [item.id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(
        AppSQL.itemsTable,
        where: 'id=?',
        whereArgs: [id],
      );
    } catch (error) {
      debugPrint('Some thing error');
    }
  }
}
