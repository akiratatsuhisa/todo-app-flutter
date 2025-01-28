import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constant.dart';
import 'package:mobile/page/login/cubit/login_cubit.dart';

class LoginPage extends StatelessWidget {
  static const _title = "Login";

  final String? redirectUrl;

  const LoginPage({
    super.key,
    this.redirectUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(_title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Constant.space6),
        children: [
          _EmailInput(),
          const SizedBox(height: Constant.space3),
          _PasswordInput(),
          const SizedBox(height: Constant.space3),
          _LoginButton(),
          const SizedBox(height: Constant.space3),
          _GoogleLoginButton(),
          BlocListener<LoginCubit, LoginState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status.isFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        state.errorMessage ?? 'Authentication Failure',
                      ),
                    ),
                  );
              }

              if (state.status.isSuccess) {
                if (redirectUrl != null) {
                  GoRouter.of(context).go(redirectUrl!);
                } else {
                  GoRouter.of(context).pop();
                }
              }
            },
            child: const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (LoginCubit cubit) => cubit.state.email.displayError,
    );

    return TextField(
      key: const Key('loginForm_emailInput_textField'),
      onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'email',
        helperText: '',
        errorText: displayError != null ? 'invalid email' : null,
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (LoginCubit cubit) => cubit.state.password.displayError,
    );

    return TextField(
      key: const Key('loginForm_passwordInput_textField'),
      onChanged: (password) =>
          context.read<LoginCubit>().passwordChanged(password),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'password',
        helperText: '',
        errorText: displayError != null ? 'invalid password' : null,
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select(
      (LoginCubit cubit) => cubit.state.status.isInProgress,
    );

    final isValid = context.select(
      (LoginCubit cubit) => cubit.state.isValid,
    );

    return FilledButton.icon(
      key: const Key('loginForm_continue_raisedButton'),
      onPressed: isValid || isInProgress
          ? () => context.read<LoginCubit>().logInWithCredentials()
          : null,
      icon: const Icon(Icons.login),
      label: const Text('Login'),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton.icon(
      key: const Key('loginForm_googleLogin_raisedButton'),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.tertiary,
        foregroundColor: theme.colorScheme.onTertiary,
      ),
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
      icon: Icon(
        FontAwesomeIcons.google,
        color: theme.colorScheme.onTertiary,
      ),
      label: const Text(
        'Sign in with Google',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
