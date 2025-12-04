import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:talker_riverpod_logger/talker_riverpod_logger.dart";

void main() {
  runApp(
    ProviderScope(
      observers: [
        TalkerRiverpodObserver(
          settings: const TalkerRiverpodLoggerSettings(
            printProviderDisposed: true,
          ),
        ),
      ],
      retry: (retryCount, error) {
        return null;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow,
        ),
      ),
      home: Container(),
    );
  }
}