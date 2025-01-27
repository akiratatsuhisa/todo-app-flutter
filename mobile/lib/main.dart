import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile/data/graphql.dart';
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
  final graphqlClient = GraphQLApi(preferences: preferences).getClient();

  boostrap(
    preferences: preferences,
    graphqlClient: graphqlClient,
  );
}

void boostrap({
  required SharedPreferences preferences,
  required GraphQLClient graphqlClient,
}) {
  final homeRepository = HomeRepository(preferences: preferences);
  final todoRepository = TodoRepository(client: graphqlClient);

  runApp(
    MyApp(
      homeRepository: homeRepository,
      todoRepository: todoRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final HomeRepository _homeRepository;
  final TodoRepository _todoRepository;

  const MyApp({
    super.key,
    required HomeRepository homeRepository,
    required TodoRepository todoRepository,
  })  : _todoRepository = todoRepository,
        _homeRepository = homeRepository;

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
      ),
    );

    final repositoryProviders = MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _homeRepository),
        RepositoryProvider.value(value: _todoRepository),
      ],
      child: materialApp,
    );

    return repositoryProviders;
  }
}
