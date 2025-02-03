import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constant.dart';
import 'package:mobile/page/register/cubit/register_cubit.dart';

class RegisterPage extends StatelessWidget {
  static const _title = "Register";

  const RegisterPage({super.key});

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
          _RegisterButton(),
          const Divider(height: Constant.space6),
          TextButton(
            child: const Text("Already have an account? Go to login page"),
            onPressed: () => GoRouter.of(context).pop(),
          ),
          BlocListener<RegisterCubit, RegisterState>(
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
                GoRouter.of(context).pop();
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
      (RegisterCubit cubit) => cubit.state.email.displayError,
    );

    return TextField(
      key: const Key('registerForm_emailInput_textField'),
      onChanged: (email) => context.read<RegisterCubit>().emailChanged(email),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'email',
        helperText: '',
        errorText: displayError?.message,
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (RegisterCubit cubit) => cubit.state.password.displayError,
    );

    return TextField(
      key: const Key('registerForm_passwordInput_textField'),
      onChanged: (password) =>
          context.read<RegisterCubit>().passwordChanged(password),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'password',
        helperText: '',
        errorText: displayError?.message,
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select(
      (RegisterCubit cubit) => cubit.state.status.isInProgress,
    );

    return FilledButton.icon(
      key: const Key('registerForm_continue_raisedButton'),
      onPressed: !isInProgress
          ? () => context.read<RegisterCubit>().registerWithCredentials()
          : null,
      icon: const Icon(Icons.person_add),
      label: const Text('Register'),
    );
  }
}
