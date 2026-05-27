import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'app_database.dart';

class SqliteHelper {
  SqliteHelper._();
  static final SqliteHelper instance = SqliteHelper._();

  Future<void> init() async => AppDatabase.instance.init();

  Future<void> clearSession() async => AppDatabase.instance.clearSession();

  Future<void> deleteAllData() async {
    final db = await AppDatabase.instance.database;
    await db.delete('session');
    await db.delete('users');
    await db.delete('skills');
    await db.delete('skill_requests');
    await db.delete('study_groups');
    await db.delete('group_members');
  }

  Future<int> insert(
    String table,
    Map<String, dynamic> values, {
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace,
  }) async {
    final db = await AppDatabase.instance.database;
    return db.insert(table, values, conflictAlgorithm: conflictAlgorithm);
  }

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await AppDatabase.instance.database;
    return db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await AppDatabase.instance.database;
    return db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final db = await AppDatabase.instance.database;
    return db.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? args,
  ]) async {
    final db = await AppDatabase.instance.database;
    return db.rawQuery(sql, args);
  }

  static const int _version = 1;

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final path = join(dir, 'campus_app.db');
    return openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id            TEXT PRIMARY KEY,
        full_name     TEXT NOT NULL,
        email         TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        bio           TEXT NOT NULL DEFAULT '',
        avatar_path   TEXT NOT NULL DEFAULT '',
        created_at    INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE session (
        id           INTEGER PRIMARY KEY,
        user_id      TEXT    NOT NULL,
        user_email   TEXT    NOT NULL,
        user_name    TEXT    NOT NULL,
        logged_in_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE skills (
        id            TEXT PRIMARY KEY,
        title         TEXT NOT NULL,
        category      TEXT NOT NULL,
        description   TEXT NOT NULL,
        owner_id      TEXT NOT NULL,
        owner_name    TEXT NOT NULL,
        owner_year    TEXT NOT NULL,
        availability  TEXT NOT NULL DEFAULT '',
        prerequisites TEXT NOT NULL DEFAULT '',
        created_at    INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE skill_requests (
        id             TEXT PRIMARY KEY,
        skill_id       TEXT NOT NULL,
        skill_title    TEXT NOT NULL,
        requester_id   TEXT NOT NULL,
        requester_name TEXT NOT NULL,
        status         TEXT NOT NULL DEFAULT 'pending',
        created_at     INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE study_groups (
        id           TEXT PRIMARY KEY,
        name         TEXT NOT NULL,
        topic        TEXT NOT NULL,
        description  TEXT NOT NULL,
        creator_id   TEXT NOT NULL,
        member_count INTEGER NOT NULL DEFAULT 1,
        created_at   INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE group_members (
        id         TEXT PRIMARY KEY,
        group_id   TEXT NOT NULL,
        user_id    TEXT NOT NULL,
        user_name  TEXT NOT NULL,
        user_field TEXT NOT NULL DEFAULT '',
        role       TEXT NOT NULL DEFAULT 'member',
        joined_at  INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Add migration steps here when schema changes in future versions.
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE skills ADD COLUMN tags TEXT DEFAULT ""');
    // }
  }
}
