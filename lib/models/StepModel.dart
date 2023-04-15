class StepModel {
  final int stepCount;
  final DateTime date;

  StepModel({
    required this.stepCount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'stepCount': stepCount,
      'date': date.toIso8601String(),
    };
  }

  factory StepModel.fromMap(Map<String, dynamic> map) {
    return StepModel(
      stepCount: map['stepCount'],
      date: DateTime.parse(map['date']),
    );
  }
}
