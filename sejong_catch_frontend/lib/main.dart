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
      body: const Center(child: Text('Hello, Sejong Catch!')),
    );
  }
}
