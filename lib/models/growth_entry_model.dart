class GrowthEntryModel {
  final int?    id;
  final String  entryType;    // 'weight' | 'height' | 'milestone' | 'note'
  final double? value;
  final String? unit;
  final String? milestone;
  final String? notes;
  final String  entryDate;

  GrowthEntryModel({
    this.id,
    required this.entryType,
    this.value,
    this.unit,
    this.milestone,
    this.notes,
    required this.entryDate,
  });

  Map<String, dynamic> toMap() => {
    'id':         id,
    'entry_type': entryType,
    'value':      value,
    'unit':       unit,
    'milestone':  milestone,
    'notes':      notes,
    'entry_date': entryDate,
  };

  factory GrowthEntryModel.fromMap(Map<String, dynamic> m) => GrowthEntryModel(
    id:        m['id'],
    entryType: m['entry_type'],
    value:     m['value'],
    unit:      m['unit'],
    milestone: m['milestone'],
    notes:     m['notes'],
    entryDate: m['entry_date'],
  );
}