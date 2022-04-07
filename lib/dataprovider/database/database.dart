import 'dart:async';
import 'dart:io';

import 'package:driverapp/models/trip/trip.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class HistoryDB {
  final _databaseName = "trip_database.db";
  final _databaseVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    //await db.execute("DROP TABLE IF EXISTS TripHistory");
    return db.execute(
      '''CREATE TABLE TripHistory(
           id TEXT PRIMARY KEY,
           date TEXT,
           froms TEXT,
           time TEXT,
           price TEXT,
           tos TEXT,
            origin TEXT,
            destination TEXT,
            picture BLOB )''',
    );
  }

  Future<void> insertTrip(Trip trip) async {
    final db = await database;
    //deleteTable("TripHistory");
    //createTable("TripHistory");
    await db.insert(
      'TripHistory',
      trip.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Trip>> trips() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('TripHistory');
    return List.generate(maps.length, (i) {
      return Trip(
        id: maps[i]['id'],
        date: maps[i]['date'],
        from: maps[i]['froms'],
        time: maps[i]['time'],
        price: maps[i]['price'],
        to: maps[i]['tos'],
        origin: LatLngConverter().latLng(maps[i]['origin']),
        destination: LatLngConverter().latLng(maps[i]['destination']),
        picture: maps[i]['picture'],
      );
    });
  }

  Future<void> updateTrip(Trip trip) async {
    final db = await database;

    await db.update(
      'TripHistory',
      trip.toMap(),
      // Ensure that the Trip has a matching id.
      where: 'id = ?',
      // Pass the Trip's id as a whereArg to prevent SQL injection.
      whereArgs: [trip.id],
    );
  }

  Future<void> deleteTrip(int id) async {
    final db = await database;

    await db.delete(
      'TripHistory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTable(String name) async {
    final db = await database;
    await db.execute("DROP TABLE IF EXISTS $name");
  }

  Future<void> createTable(String name) async {
    final db = await database;
    return db.execute(
      '''CREATE TABLE $name(
           id TEXT PRIMARY KEY,
           date TEXT,
           froms TEXT,
           time TEXT,
           price TEXT,
           tos TEXT,
            origin TEXT,
            destination TEXT,
            picture BLOB )''',
    );
  }
}
