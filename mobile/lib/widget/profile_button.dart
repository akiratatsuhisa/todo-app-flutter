import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/bloc/auth_bloc.dart';
import 'package:mobile/constant.dart';
import 'package:mobile/model/user.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthBloc, AuthState, User>(
      selector: (state) => state.user,
      builder: (context, user) => IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const _ProfileDialog(),
          );
        },
        icon: _Avatar(
          url: user.photo,
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final double? radius;
  final String? url;

  const _Avatar({this.radius, this.url});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: url == null
          ? const AssetImage("assets/default-avatar.png")
          : NetworkImage(url!),
    );
  }
}

class _ProfileDialog extends StatelessWidget {
  const _ProfileDialog();

  @override
  Widget build(BuildContext context) {
    final userInfo = BlocSelector<AuthBloc, AuthState, User>(
      selector: (state) => state.user,
      builder: (context, user) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: _Avatar(
              radius: 48.0,
              url: user.photo,
            ),
          ),
          ListTile(
            title: const Text("Email"),
            subtitle: Text(user.email ?? ''),
          ),
          ListTile(
            title: const Text("Name"),
            subtitle: Text(user.name ?? ''),
          ),
        ],
      ),
    );

    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Constant.space5).copyWith(
            bottom: Constant.space3,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              userInfo,
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthLogoutPressed());
                  Navigator.pop(context);
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
