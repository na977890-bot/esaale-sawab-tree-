import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Esaale Sawab Tree',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const TreePage(),
    );
  }
}

class TreePage extends StatefulWidget {
  const TreePage({super.key});
  @override
  State<TreePage> createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text('Esaale Sawab Tree 🌳'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🌳', style: TextStyle(fontSize: 120 + (count * 2).toDouble().clamp(0, 80))),
            const SizedBox(height: 20),
            Text('Total Sawab: $count', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Har click pe ek neiki', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () => setState(() => count++),
              child: const Text('Sawab Bhejo 🤲', style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => setState(() => count = 0),
              child: const Text('Reset'),
            )
          ],
        ),
      ),
    );
  }
}
