import 'package:flutter/material.dart';
import 'package:mobile/interface/error_state.dart';

class ErrorContent<E extends ErrorState> extends StatelessWidget {
  final Object state;
  final VoidCallback onRetryPressed;

  const ErrorContent({
    super.key,
    required this.state,
    required this.onRetryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final currentState = state;
    if (currentState is! E) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentState.message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            FilledButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: onRetryPressed,
              style: FilledButton.styleFrom(
                visualDensity: const VisualDensity(horizontal: 4.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
