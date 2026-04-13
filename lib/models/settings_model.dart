class SettingsModel {
  final int?   id;
  final String motherName;
  final String babyGender;
  final String dueDate;       // ISO-8601
  final int    themeColor;    // Color.value integer

  SettingsModel({
    this.id,
    required this.motherName,
    required this.babyGender,
    required this.dueDate,
    required this.themeColor,
  });

  Map<String, dynamic> toMap() => {
    'id':           id,
    'mother_name':  motherName,
    'baby_gender':  babyGender,
    'due_date':     dueDate,
    'theme_color':  themeColor,
    'created_at':   DateTime.now().toIso8601String(),
  };

  factory SettingsModel.fromMap(Map<String, dynamic> m) => SettingsModel(
    id:          m['id'],
    motherName:  m['mother_name'],
    babyGender:  m['baby_gender'],
    dueDate:     m['due_date'],
    themeColor:  m['theme_color'],
  );
}