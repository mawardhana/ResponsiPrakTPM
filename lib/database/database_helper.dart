import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:encrypt/encrypt.dart';

import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._getInstance();
  static Database? _database;
  static final _encryptionKey = Key.fromLength(32);
  static final _iv = IV.fromLength(16);
  static final _encrypter = Encrypter(AES(_encryptionKey));

  DatabaseHelper._getInstance();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'appdatabase.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        email TEXT,
        password TEXT,
        nim TEXT
      )
    ''');
  }

  Future<int> saveUser(UserModel user) async {
    final db = await database;
    final userModelMap = user.toJson();
    final encryptedPassword = _encrypter.encrypt(user.password, iv: _iv);
    userModelMap['password'] = encryptedPassword.base64;
    return await db.insert('users', userModelMap);
  }

  Future<UserModel?> getUser(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      final userModelMap = maps.first;
      final encryptedPassword = Encrypted.fromBase64(userModelMap['password']);
      final decryptedPassword = _encrypter.decrypt(encryptedPassword, iv: _iv);
      final modifiedUserModelMap = Map<String, dynamic>.from(userModelMap);
      modifiedUserModelMap['password'] = decryptedPassword;
      return UserModel.fromJson(modifiedUserModelMap);
    }
    return null;
  }
}