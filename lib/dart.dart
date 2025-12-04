
class Exercise {
  final String name;
  final int score;
  final DateTime submittedAt;

  Exercise({
    required this.name,
    required this.score,
    required this.submittedAt,
  });
}

bool isPassed(Exercise exercise) {
  return exercise.score >= 60;
}

List<Exercise> passedOnly(List<Exercise> exercises) {
  return exercises.where((exercise) => isPassed(exercise)).toList();
}

double? averageScore(List<Exercise> exercises) {
  if (exercises.isEmpty) return null;
  
  int total = 0;
  for (var exercise in exercises) {
    total += exercise.score;
  }
  
  return total / exercises.length;
}

String bestStudent(List<Exercise> exercises) {
  if (exercises.isEmpty) return '';
  
  Exercise best = exercises[0];
  for (var exercise in exercises) {
    if (exercise.score > best.score) {
      best = exercise;
    }
  }
  
  return best.name;
}
