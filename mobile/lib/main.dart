import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile/repository/todo_repository.dart';
import 'router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final httpLink = HttpLink('http://10.0.2.2:8080/graphql');

    final authLink = AuthLink(getToken: () async => '');

    final link = authLink.concat(httpLink);

    final client = ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(
          store: InMemoryStore(),
        ),
        defaultPolicies: DefaultPolicies(
          query: Policies(fetch: FetchPolicy.noCache),
        ),
      ),
    );

    return GraphQLProvider(
      client: client,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) {
            return TodoRepository(client: client.value);
          }),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          title: 'Flutter Todo App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
