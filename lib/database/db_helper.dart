import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DbHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE friend(
        cId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        cFirstName TEXT,
        cLastName TEXT,
        cEmail TEXT,
        cMobile TEXT,
        cPassword TEXT
      )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'friend.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createFriend(
      {required String cFirstName,
      required String cLastName,
      required String cEmail,
      required String cMobile,
      required String cPassword}) async {
    final db = await DbHelper.db();
    final data = {
      'cFirstName': cFirstName,
      'cLastName': cLastName,
      'cEmail': cEmail,
      'cMobile': cMobile,
      'cPassword': cPassword
    };
    final id = await db.insert(
      'friend',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> readFriends() async {
    final db = await DbHelper.db();
    return db.query('friend', orderBy: "cId");
  }

  static Future<List<Map<String, dynamic>>> readFriendById(int id) async {
    final db = await DbHelper.db();
    return db.query('friend', where: "cId = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateFriend(
      {required int cId,
      required String cFirstName,
      required String cLastName,
      required String cEmail,
      required String cMobile,
      required String cPassword}) async {
    final db = await DbHelper.db();
    final data = {
      'cFirstName': cFirstName,
      'cLastName': cLastName,
      'cEmail': cEmail,
      'cMobile': cMobile,
      'cPassword': cPassword
    };
    final result = await db.update(
      'friend',
      data,
      where: "cId = ?",
      whereArgs: [cId],
    );
    return result;
  }

  static Future<void> deleteFriend(int id) async {
    final db = await DbHelper.db();
    try {
      await db.delete(
        "friend",
        where: "cId = ?",
        whereArgs: [id],
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
