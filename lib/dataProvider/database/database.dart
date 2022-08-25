import 'dart:async';
import 'dart:io';
import 'package:driverapp/models/trip/trip.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
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
           createdAt TEXT,
           updatedAt TEXT,
           pickUpAddress TEXT,
           dropOffAddress TEXT,
           price TEXT,
           status TEXT,
           passenger TEXT,
            pickUpLocation TEXT,
            dropOffLocation TEXT,
            picture BLOB )''',
    );
  }

  Future<int> insertTrip(Trip trip) async {
    final db = await database;
    //deleteTable("TripHistory");
    //createTable("TripHistory");
    return await db.insert(
      'TripHistory',
      trip.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    //return 0;
  }

  Future<num> insertTrips(List<Trip> trips) async {
    num count = 0;
    for (Trip trip in trips) {
      count += await insertTrip(trip);
    }
    return count;
  }

  Future<List<Trip>> trips() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('TripHistory');
    return List.generate(maps.length, (i) {
      return Trip(
        id: maps[i]['id'],
        createdAt: maps[i]['createdAt'],
        commission: maps[i]['commission'],
        startingTime: maps[i]['startingTime'],
        pickUpAddress: maps[i]['pickUpAddress'],
        updatedAt: maps[i]['updatedAt'],
        distance: maps[i]['distance'],
        price: maps[i]['price'],
        netPrice: maps[i]['netPrice'],
        status: maps[i]['status'],
        passenger: maps[i]['passenger'],
        dropOffAddress: maps[i]['dropOffAddress'],
        pickUpLocation: LatLngConverter().latLng(maps[i]['pickUpLocation']),
        dropOffLocation: LatLngConverter().latLng(maps[i]['dropOffLocation']),
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
           createdAt TEXT,
           updatedAt TEXT,
           pickUpAddress TEXT,
           dropOffAddress TEXT,
           price TEXT,
           status TEXT,
           passenger TEXT,
            pickUpLocation TEXT,
            dropOffLocation TEXT,
            picture BLOB )''',
    );
  }
}
