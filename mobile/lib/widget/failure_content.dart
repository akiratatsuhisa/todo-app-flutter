import 'package:flutter/material.dart';
import 'package:mobile/constant.dart';
import 'package:mobile/interface/failure_state.dart';

class FailureContent<E extends FailureState> extends StatelessWidget {
  final Object state;
  final VoidCallback onRetryPressed;

  const FailureContent({
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
      padding: const EdgeInsets.all(Constant.space6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentState.title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Constant.space2),
            Text(
              currentState.message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Constant.space4),
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
