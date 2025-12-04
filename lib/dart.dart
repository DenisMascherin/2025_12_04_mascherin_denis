class Exercise {
  final String name;
  final int score;
  final DateTime submittedAt;

  Exercise({
    required this.name,
    required this.score,
    required this.submittedAt,
  });

  bool get isPassed => score >= 60;
}

List<Exercise> passedOnly(List<Exercise> exercises) {
  return exercises.where((e) => e.isPassed).toList();
}

double? averageScore(List<Exercise> exercises) {
  if (exercises.isEmpty) return null;
  return exercises.map((e) => e.score).reduce((a, b) => a + b) / exercises.length;
}

String bestStudent(List<Exercise> exercises) {
  if (exercises.isEmpty) return '';
  return exercises.reduce((a, b) => a.score > b.score ? a : b).name;
}