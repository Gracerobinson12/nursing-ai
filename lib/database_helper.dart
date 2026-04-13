import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('postpartum_care.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // ── Settings ──────────────────────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE settings (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        mother_name TEXT    NOT NULL,
        baby_gender TEXT    NOT NULL,
        due_date    TEXT    NOT NULL,
        theme_color INTEGER NOT NULL,
        created_at  TEXT    NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    // ── Mom's Daily Goals ─────────────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE goals (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        title       TEXT    NOT NULL,
        is_complete INTEGER NOT NULL DEFAULT 0,
        date        TEXT    NOT NULL,
        created_at  TEXT    NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    // ── Baby Activities ───────────────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE baby_activities (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        type        TEXT    NOT NULL,   -- 'Feeding' | 'Diaper' | 'Sleep'
        notes       TEXT,
        logged_at   TEXT    NOT NULL DEFAULT (datetime('now')),
        duration_min INTEGER            -- optional, useful for Sleep entries
      )
    ''');

    // ── Self-Care Reminders ───────────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE self_care_reminders (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        title        TEXT    NOT NULL,
        description  TEXT,
        icon_code    INTEGER NOT NULL,  -- IconData.codePoint
        is_enabled   INTEGER NOT NULL DEFAULT 1,
        remind_time  TEXT,              -- e.g. "08:00"
        created_at   TEXT    NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    // ── Self-Care Logs (mood + completed reminders) ───────────────────────────
    await db.execute('''
      CREATE TABLE self_care_logs (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        mood         TEXT    NOT NULL,  -- 'Good' | 'Calm' | 'Tired' | 'Sad'
        reminder_id  INTEGER,
        completed    INTEGER NOT NULL DEFAULT 0,
        logged_at    TEXT    NOT NULL DEFAULT (datetime('now')),
        FOREIGN KEY (reminder_id) REFERENCES self_care_reminders(id)
      )
    ''');

    // ── Growth Tracker ────────────────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE growth_entries (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        entry_type   TEXT    NOT NULL,  -- 'weight' | 'height' | 'milestone' | 'note'
        value        REAL,              -- numeric value for weight/height
        unit         TEXT,              -- 'kg' | 'lbs' | 'cm' | 'in'
        milestone    TEXT,              -- e.g. "First smile", "Rolled over"
        notes        TEXT,
        entry_date   TEXT    NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    // ── Seed default self-care reminders ─────────────────────────────────────
    await _seedDefaultReminders(db);
  }

  Future _seedDefaultReminders(Database db) async {
    final defaults = [
      {'title': 'Hydration',  'description': 'Drink a glass of water',    'icon_code': 0xe798}, // local_drink
      {'title': 'Nutrition',  'description': 'Have a healthy snack',       'icon_code': 0xe56c}, // restaurant_menu
      {'title': 'Rest',       'description': 'Take a 15-minute break',     'icon_code': 0xe33d}, // chair
      {'title': 'Movement',   'description': 'Gentle stretching',          'icon_code': 0xe594}, // self_improvement
      {'title': 'Connection', 'description': 'Call a friend or family',    'icon_code': 0xe0b0}, // phone
    ];
    for (final r in defaults) {
      await db.insert('self_care_reminders', {
        ...r,
        'is_enabled': 1,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }
}