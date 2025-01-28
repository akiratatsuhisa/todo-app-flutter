import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile/bloc/auth_bloc.dart';
import 'package:mobile/api/graphql.dart';
import 'package:mobile/repository/authentication_repository.dart';
import 'package:mobile/repository/home_repository.dart';
import 'package:mobile/repository/todo_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final preferences = await SharedPreferences.getInstance();
  final graphqlClient = GraphQLApi().getClient();

  await boostrap(
    preferences: preferences,
    graphqlClient: graphqlClient,
  );
}

Future<void> boostrap({
  required SharedPreferences preferences,
  required GraphQLClient graphqlClient,
}) async {
  final homeRepository = HomeRepository(preferences: preferences);
  final todoRepository = TodoRepository(client: graphqlClient);
  final authenticationRepository = AuthenticationRepository();

  await authenticationRepository.user.first;

  runApp(
    MyApp(
      homeRepository: homeRepository,
      todoRepository: todoRepository,
      authenticationRepository: authenticationRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final HomeRepository _homeRepository;
  final TodoRepository _todoRepository;
  final AuthenticationRepository _authenticationRepository;

  const MyApp({
    super.key,
    required HomeRepository homeRepository,
    required TodoRepository todoRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _todoRepository = todoRepository,
        _homeRepository = homeRepository,
        _authenticationRepository = authenticationRepository;
  @override
  Widget build(BuildContext context) {
    final materialApp = MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
    );

    final providers = MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _homeRepository),
        RepositoryProvider.value(value: _todoRepository),
        RepositoryProvider.value(value: _authenticationRepository),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          authenticationRepository: context.read<AuthenticationRepository>(),
        )..add(const AuthUserSubscriptionRequested()),
        child: materialApp,
      ),
    );

    return providers;
  }
}
