import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Home Page'),
            const SizedBox(height: 24.0),
            FilledButton(
              onPressed: () =>
                  GoRouter.of(context).goNamed(Routes.todo.name),
              child: const Text("Todo"),
            )
          ],
        ),
      ),
    );
  }
}
