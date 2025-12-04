import 'package:flutter/main.dart';
import 'dart.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ExerciseHomePage(),
    );
  }
}

final exercisesProvider = StateProvider<List<Exercise>>((ref) {
  return [
    Exercise(name: 'Simone Rossi', score: 85, submittedAt: DateTime.now()),
    Exercise(name: 'Mario Baccini', score: 92, submittedAt: DateTime.now()),
    Exercise(name: 'Tommaso D'Acquino', score: 45, submittedAt: DateTime.now()),
    Exercise(name: 'Alice Brown', score: 78, submittedAt: DateTime.now()),
    Exercise(name: 'Tom Davis', score: 60, submittedAt: DateTime.now()),
  ];
});

class ExerciseHomePage extends ConsumerWidget {
  const ExerciseHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercises = ref.watch(exercisesProvider);
    final passedExercises = passedOnly(exercises);
    final average = averageScore(exercises) ?? 0.0;
    final topStudent = exercises.isEmpty ? 'None' : bestStudent(exercises);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Manager'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Text('Total exercises: ${exercises.length}'),
                    Text('Passed (≥60): ${passedExercises.length}'),
                    Text('Average score: ${average.toStringAsFixed(1)}'),
                    Text('Best student: $topStudent'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            Text(
              'All Exercises',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return ListTile(
                    title: Text(exercise.name),
                    trailing: Text(
                      '${exercise.score}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: exercise.score >= 60 ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 25),
            Text(
              'Passed Students Only',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ...passedExercises.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('✓ ${e.name}: ${e.score}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}