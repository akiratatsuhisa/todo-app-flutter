import 'package:flutter/material.dart';

class TodoDetailPage extends StatelessWidget {
  final String id;

  const TodoDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('TodoDetailPage $id'),
      ),
    );
  }
}
