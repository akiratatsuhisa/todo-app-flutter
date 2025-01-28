import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/bloc/auth_bloc.dart';
import 'package:mobile/page/home/bloc/home_bloc.dart';
import 'package:mobile/page/home/welcome_content.dart';
import 'package:mobile/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<HomeBloc>().add(const HomeWelcomeReadingChecked());

    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      listener: (context, state) {
        if (state is! HomeDone) {
          return;
        }

        final status = context.read<AuthBloc>().state.status;

        if (status == AuthStatus.unauthenticated) {
          GoRouter.of(context).goNamed(Routes.login.name, queryParameters: {
            'redirectUrl': Routes.todo.path,
          });
          return;
        }

        GoRouter.of(context).goNamed(Routes.todo.name);
      },
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) => switch (state) {
        HomeInProgress _ => const WelcomeContent(),
        _ => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      },
    );
  }
}
