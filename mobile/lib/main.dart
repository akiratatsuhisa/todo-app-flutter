import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile/data/graphql.dart';
import 'package:mobile/repository/home_repository.dart';
import 'package:mobile/repository/todo_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final graphqlClient = GraphQLApi(preferences: preferences).getClient();

  runApp(
    MyApp(
      preferences: preferences,
      graphQLClient: graphqlClient,
    ),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;
  final GraphQLClient graphQLClient;

  const MyApp({
    super.key,
    required this.preferences,
    required this.graphQLClient,
  });

  // This widget is the root of your application.
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
        RepositoryProvider(
          create: (context) {
            return HomeRepository(preferences: preferences);
          },
        ),
        RepositoryProvider(
          create: (context) {
            return TodoRepository(client: graphQLClient);
          },
        ),
      ],
      child: materialApp,
    );

    final graphQLProvider = GraphQLProvider(
      client: ValueNotifier(graphQLClient),
      child: repositoryProviders,
    );

    return graphQLProvider;
  }
}
