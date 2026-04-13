import '../database_helper.dart';
import '../models/settings_model.dart';
import '../models/goal_model.dart';
import '../models/baby_activity_model.dart';
import '../models/self_care_reminder_model.dart';
import '../models/growth_entry_model.dart';

class AppRepository {
  final db = DatabaseHelper.instance;

  // ── Settings ──────────────────────────────────────────────────────────────

  Future<void> saveSettings(SettingsModel s) async {
    final database = await db.database;
    final existing = await database.query('settings', limit: 1);
    if (existing.isEmpty) {
      await database.insert('settings', s.toMap());
    } else {
      await database.update('settings', s.toMap(),
          where: 'id = ?', whereArgs: [existing.first['id']]);
    }
  }

  Future<SettingsModel?> getSettings() async {
    final database = await db.database;
    final rows = await database.query('settings', limit: 1);
    return rows.isEmpty ? null : SettingsModel.fromMap(rows.first);
  }

  // ── Goals ─────────────────────────────────────────────────────────────────

  Future<int> insertGoal(GoalModel goal) async {
    final database = await db.database;
    return await database.insert('goals', goal.toMap());
  }

  Future<List<GoalModel>> getGoalsForDate(String date) async {
    final database = await db.database;
    final rows = await database.query('goals',
        where: 'date = ?', whereArgs: [date], orderBy: 'created_at ASC');
    return rows.map(GoalModel.fromMap).toList();
  }

  Future<void> toggleGoal(int id, bool isComplete) async {
    final database = await db.database;
    await database.update('goals', {'is_complete': isComplete ? 1 : 0},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteGoal(int id) async {
    final database = await db.database;
    await database.delete('goals', where: 'id = ?', whereArgs: [id]);
  }

  // ── Baby Activities ───────────────────────────────────────────────────────

  Future<int> logBabyActivity(BabyActivityModel activity) async {
    final database = await db.database;
    return await database.insert('baby_activities', activity.toMap());
  }

  Future<List<BabyActivityModel>> getRecentActivities({int limit = 20}) async {
    final database = await db.database;
    final rows = await database.query('baby_activities',
        orderBy: 'logged_at DESC', limit: limit);
    return rows.map(BabyActivityModel.fromMap).toList();
  }

  Future<BabyActivityModel?> getLastActivityByType(String type) async {
    final database = await db.database;
    final rows = await database.query('baby_activities',
        where: 'type = ?',
        whereArgs: [type],
        orderBy: 'logged_at DESC',
        limit: 1);
    return rows.isEmpty ? null : BabyActivityModel.fromMap(rows.first);
  }

  Future<void> deleteBabyActivity(int id) async {
    final database = await db.database;
    await database.delete('baby_activities', where: 'id = ?', whereArgs: [id]);
  }

  // ── Self-Care Reminders ───────────────────────────────────────────────────

  Future<List<SelfCareReminderModel>> getReminders() async {
    final database = await db.database;
    final rows = await database.query('self_care_reminders',
        orderBy: 'created_at ASC');
    return rows.map(SelfCareReminderModel.fromMap).toList();
  }

  Future<void> toggleReminder(int id, bool isEnabled) async {
    final database = await db.database;
    await database.update('self_care_reminders', {'is_enabled': isEnabled ? 1 : 0},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> logMood(String mood) async {
    final database = await db.database;
    await database.insert('self_care_logs', {
      'mood':      mood,
      'completed': 0,
      'logged_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> markReminderComplete(int reminderId) async {
    final database = await db.database;
    await database.insert('self_care_logs', {
      'reminder_id': reminderId,
      'mood':        '',
      'completed':   1,
      'logged_at':   DateTime.now().toIso8601String(),
    });
  }

  // ── Growth Tracker ────────────────────────────────────────────────────────

  Future<int> insertGrowthEntry(GrowthEntryModel entry) async {
    final database = await db.database;
    return await database.insert('growth_entries', entry.toMap());
  }

  Future<List<GrowthEntryModel>> getGrowthEntries({String? type}) async {
    final database = await db.database;
    final rows = await database.query(
      'growth_entries',
      where:     type != null ? 'entry_type = ?' : null,
      whereArgs: type != null ? [type] : null,
      orderBy:   'entry_date DESC',
    );
    return rows.map(GrowthEntryModel.fromMap).toList();
  }

  Future<void> deleteGrowthEntry(int id) async {
    final database = await db.database;
    await database.delete('growth_entries', where: 'id = ?', whereArgs: [id]);
  }
}