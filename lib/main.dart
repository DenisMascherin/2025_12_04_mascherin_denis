import "package:flutter/material.dart";
import 'dart.dart';

void main() {
  runApp(const MyApp());
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

class ExerciseHomePage extends StatelessWidget {
  const ExerciseHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final exercises = [
      Exercise(name: 'Simone Rossi', score: 85, submittedAt: DateTime.now()),
      Exercise(name: 'Mario Baccini', score: 92, submittedAt: DateTime.now()),
      Exercise(name: 'Tommaso Neri', score: 88, submittedAt: DateTime.now()),
      Exercise(name: 'Davide Minimi', score: 65, submittedAt: DateTime.now()),
      Exercise(name: 'Lorenzo Massimi', score: 60, submittedAt: DateTime.now()),
    ];

    final passed = passedOnly(exercises);
    final avg = averageScore(exercises) ?? 0.0;
    final top = exercises.isEmpty ? 'Nessuno' : bestStudent(exercises);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Esercizi Studenti'),
        backgroundColor: const Color.fromARGB(255, 30, 143, 235),
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
                    Text('Statistiche', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    Text('Totale: ${exercises.length}'),
                    Text('Passati: ${passed.length}'),
                    Text('Media: ${avg.toStringAsFixed(1)}'),
                    Text('Migliore: $top'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Tutti gli esercizi', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final ex = exercises[index];
                  return ListTile(
                    title: Text(ex.name),
                    trailing: Text(
                      '${ex.score}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ex.isPassed ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Text('Solo voti sufficienti:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...passed.map((e) => Text('✓ ${e.name}: ${e.score}')),
          ],
        ),
      ),
    );
  }
}