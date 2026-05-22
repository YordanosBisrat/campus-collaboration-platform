import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  /// Called once from main() before runApp
  Future<void> init() async {
    await database;
  }

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final path = join(dir, 'campus_app.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // ── users ────────────────────────────────────────────────────────────
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

    // ── session (one row = logged-in user) ───────────────────────────────
    await db.execute('''
      CREATE TABLE session (
        id           INTEGER PRIMARY KEY,
        user_id      TEXT    NOT NULL,
        user_email   TEXT    NOT NULL,
        user_name    TEXT    NOT NULL,
        logged_in_at INTEGER NOT NULL
      )
    ''');

    // ── skills ───────────────────────────────────────────────────────────
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

    // ── skill_requests ───────────────────────────────────────────────────
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

    // ── study_groups ─────────────────────────────────────────────────────
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

    // ── group_members ────────────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE group_members (
        id        TEXT PRIMARY KEY,
        group_id  TEXT NOT NULL,
        user_id   TEXT NOT NULL,
        user_name TEXT NOT NULL,
        user_field TEXT NOT NULL DEFAULT '',
        role      TEXT NOT NULL DEFAULT 'member',
        joined_at INTEGER NOT NULL
      )
    ''');
  }

  /// Wipe session on logout — does NOT touch user data
  Future<void> clearSession() async {
    final db = await database;
    await db.delete('session');
  }
}