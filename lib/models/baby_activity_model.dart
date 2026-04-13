class BabyActivityModel {
  final int?   id;
  final String type;          // 'Feeding' | 'Diaper' | 'Sleep'
  final String? notes;
  final String loggedAt;      // ISO-8601
  final int?   durationMin;

  BabyActivityModel({
    this.id,
    required this.type,
    this.notes,
    required this.loggedAt,
    this.durationMin,
  });

  Map<String, dynamic> toMap() => {
    'id':           id,
    'type':         type,
    'notes':        notes,
    'logged_at':    loggedAt,
    'duration_min': durationMin,
  };

  factory BabyActivityModel.fromMap(Map<String, dynamic> m) => BabyActivityModel(
    id:          m['id'],
    type:        m['type'],
    notes:       m['notes'],
    loggedAt:    m['logged_at'],
    durationMin: m['duration_min'],
  );
}