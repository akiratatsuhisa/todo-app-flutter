import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/bloc/auth_bloc.dart';
import 'package:mobile/constant.dart';
import 'package:mobile/router.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  Future<void> _pushLogin(BuildContext context) async =>
      await GoRouter.of(context).pushNamed(Routes.login.name);

  Widget _buildNotifyView(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Constant.space6),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Access Denied",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Constant.space2),
                const Text(
                  "Please log in to continue using the app",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Constant.space4),
                FilledButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Go to Login Screen'),
                  onPressed: () {
                    _pushLogin(context);
                  },
                  style: FilledButton.styleFrom(
                    visualDensity: const VisualDensity(horizontal: 4.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          SchedulerBinding.instance.addPostFrameCallback((_) async {
            await _pushLogin(context);
          });

          return _buildNotifyView(context);
        }

        return child;
      },
    );
  }
}
