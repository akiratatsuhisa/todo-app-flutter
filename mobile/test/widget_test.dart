// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/graphql.dart';

import 'package:mobile/main.dart';
import 'package:mobile/repository/authentication_repository.dart';
import 'package:mobile/repository/home_repository.dart';
import 'package:mobile/repository/todo_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final preferences = await SharedPreferences.getInstance();
    final graphqlClient = GraphQLApi().getClient();

    final homeRepository = HomeRepository(preferences: preferences);
    final todoRepository = TodoRepository(client: graphqlClient);
    final authenticationRepository = AuthenticationRepository();
    
    await authenticationRepository.user.first;

    await tester.pumpWidget(
      MyApp(
        homeRepository: homeRepository,
        todoRepository: todoRepository,
        authenticationRepository: authenticationRepository,
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
