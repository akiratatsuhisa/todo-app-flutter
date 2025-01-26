import 'package:flutter/material.dart';

class TodoUpdatePage extends StatelessWidget {
  final String id;

  const TodoUpdatePage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('TodoUpdatePage $id'),
      ),
    );
  }
}
