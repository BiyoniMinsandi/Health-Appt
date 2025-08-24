// services/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/health_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'health_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        userType TEXT NOT NULL,
        password TEXT NOT NULL,
        contactNumber TEXT,
        specialization TEXT,
        hospitalId TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE health_data(
        id TEXT PRIMARY KEY,
        patientId TEXT NOT NULL,
        dataType TEXT NOT NULL,
        value REAL NOT NULL,
        unit TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (patientId) REFERENCES users (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE messages(
        id TEXT PRIMARY KEY,
        senderId TEXT NOT NULL,
        receiverId TEXT NOT NULL,
        message TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        messageType TEXT DEFAULT 'text'
      )
    ''');
  }

  Future<String?> insertUser(User user, String password) async {
    final db = await database;
    try {
      await db.insert('users', {
        ...user.toJson(),
        'password': password,
      });
      return user.id;
    } catch (e) {
      return null;
    }
  }

  Future<User?> getUser(String email, String password) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<void> insertHealthData(HealthData data) async {
    final db = await database;
    await db.insert('health_data', data.toJson());
  }

  Future<List<HealthData>> getHealthData(String patientId) async {
    final db = await database;
    final maps = await db.query(
      'health_data',
      where: 'patientId = ?',
      whereArgs: [patientId],
      orderBy: 'timestamp DESC',
    );
    
    return List.generate(maps.length, (i) {
      return HealthData.fromJson(maps[i]);
    });
  }
}
