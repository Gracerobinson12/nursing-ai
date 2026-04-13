class GoalModel {
  final int?   id;
  final String title;
  final bool   isComplete;
  final String date;          // "YYYY-MM-DD"

  GoalModel({
    this.id,
    required this.title,
    this.isComplete = false,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'id':          id,
    'title':       title,
    'is_complete': isComplete ? 1 : 0,
    'date':        date,
    'created_at':  DateTime.now().toIso8601String(),
  };

  factory GoalModel.fromMap(Map<String, dynamic> m) => GoalModel(
    id:         m['id'],
    title:      m['title'],
    isComplete: m['is_complete'] == 1,
    date:       m['date'],
  );
}