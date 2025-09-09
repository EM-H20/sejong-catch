import 'package:flutter/material.dart';

void main() {
  runApp(const SejongCatchApp());
}

class SejongCatchApp extends StatelessWidget {
  const SejongCatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sejong Catch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sejong Catch')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WidgetShowcase()),
            );
          },
          child: const Text('Go to Widget Showcase'),
        ),
      ),
    );
  }
}

class WidgetShowcase extends StatelessWidget {
  const WidgetShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Showcase')),
      body: const Center(child: Text('Welcome to Widget Showcase!')),
    );
  }
}
