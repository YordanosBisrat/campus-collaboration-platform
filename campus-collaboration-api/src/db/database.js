// src/db/database.js
const Database = require('better-sqlite3');
const path = require('path');

const DB_PATH = path.join(__dirname, '../../campus_api.db');

let db;

function getDb() {
  if (!db) {
    db = new Database(DB_PATH);
    db.pragma('journal_mode = WAL');
    db.pragma('foreign_keys = ON');
    initSchema();
  }
  return db;
}

function initSchema() {
  db.exec(`
    -- ── Users ──────────────────────────────────────────────────────────
    CREATE TABLE IF NOT EXISTS users (
      id           TEXT PRIMARY KEY,
      full_name    TEXT NOT NULL,
      email        TEXT NOT NULL UNIQUE,
      password_hash TEXT NOT NULL,
      bio          TEXT NOT NULL DEFAULT '',
      avatar_path  TEXT NOT NULL DEFAULT '',
      role         TEXT NOT NULL DEFAULT 'student',
      created_at   INTEGER NOT NULL
    );

    -- ── Skills ─────────────────────────────────────────────────────────
    CREATE TABLE IF NOT EXISTS skills (
      id            TEXT PRIMARY KEY,
      title         TEXT NOT NULL,
      category      TEXT NOT NULL,
      description   TEXT NOT NULL,
      owner_id      TEXT NOT NULL,
      owner_name    TEXT NOT NULL,
      owner_year    TEXT NOT NULL DEFAULT '',
      availability  TEXT NOT NULL DEFAULT '',
      prerequisites TEXT NOT NULL DEFAULT '',
      created_at    INTEGER NOT NULL,
      FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
    );

    -- ── Skill Requests ──────────────────────────────────────────────────
    CREATE TABLE IF NOT EXISTS skill_requests (
      id             TEXT PRIMARY KEY,
      skill_id       TEXT NOT NULL,
      skill_title    TEXT NOT NULL,
      requester_id   TEXT NOT NULL,
      requester_name TEXT NOT NULL,
      status         TEXT NOT NULL DEFAULT 'pending',
      created_at     INTEGER NOT NULL,
      FOREIGN KEY (skill_id)     REFERENCES skills(id) ON DELETE CASCADE,
      FOREIGN KEY (requester_id) REFERENCES users(id) ON DELETE CASCADE
    );

    -- ── Study Groups ────────────────────────────────────────────────────
    CREATE TABLE IF NOT EXISTS study_groups (
      id           TEXT PRIMARY KEY,
      name         TEXT NOT NULL,
      topic        TEXT NOT NULL,
      description  TEXT NOT NULL,
      creator_id   TEXT NOT NULL,
      member_count INTEGER NOT NULL DEFAULT 1,
      created_at   INTEGER NOT NULL,
      FOREIGN KEY (creator_id) REFERENCES users(id) ON DELETE CASCADE
    );

    -- ── Group Members ───────────────────────────────────────────────────
    CREATE TABLE IF NOT EXISTS group_members (
      id         TEXT PRIMARY KEY,
      group_id   TEXT NOT NULL,
      user_id    TEXT NOT NULL,
      user_name  TEXT NOT NULL,
      user_field TEXT NOT NULL DEFAULT '',
      role       TEXT NOT NULL DEFAULT 'member',
      joined_at  INTEGER NOT NULL,
      FOREIGN KEY (group_id) REFERENCES study_groups(id) ON DELETE CASCADE,
      FOREIGN KEY (user_id)  REFERENCES users(id) ON DELETE CASCADE,
      UNIQUE(group_id, user_id)
    );
  `);
}

// For testing — use in-memory DB
function getTestDb() {
  const testDb = new Database(':memory:');
  testDb.pragma('foreign_keys = ON');
  db = testDb;
  initSchema();
  return testDb;
}

function closeDb() {
  if (db) {
    db.close();
    db = null;
  }
}

module.exports = { getDb, getTestDb, closeDb };
