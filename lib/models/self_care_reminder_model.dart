class SelfCareReminderModel {
  final int?   id;
  final String title;
  final String? description;
  final int    iconCode;
  final bool   isEnabled;
  final String? remindTime;   // "HH:mm"

  SelfCareReminderModel({
    this.id,
    required this.title,
    this.description,
    required this.iconCode,
    this.isEnabled = true,
    this.remindTime,
  });

  Map<String, dynamic> toMap() => {
    'id':          id,
    'title':       title,
    'description': description,
    'icon_code':   iconCode,
    'is_enabled':  isEnabled ? 1 : 0,
    'remind_time': remindTime,
    'created_at':  DateTime.now().toIso8601String(),
  };

  factory SelfCareReminderModel.fromMap(Map<String, dynamic> m) => SelfCareReminderModel(
    id:          m['id'],
    title:       m['title'],
    description: m['description'],
    iconCode:    m['icon_code'],
    isEnabled:   m['is_enabled'] == 1,
    remindTime:  m['remind_time'],
  );
}