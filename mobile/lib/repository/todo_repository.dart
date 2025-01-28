import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile/model/todo.dart';
import 'package:mobile/graphql/scheme.graphql.dart';
import 'package:mobile/graphql/todo/archive.graphql.dart';
import 'package:mobile/graphql/todo/complete.graphql.dart';
import 'package:mobile/graphql/todo/create.graphql.dart';
import 'package:mobile/graphql/todo/detail.graphql.dart';
import 'package:mobile/graphql/todo/list.graphql.dart';
import 'package:mobile/graphql/todo/remove.graphql.dart';
import 'package:mobile/graphql/todo/update.graphql.dart';

class TodoRepository {
  final GraphQLClient _client;

  TodoRepository({required GraphQLClient client}) : _client = client;

  Future<List<Todo>> getTodos(bool? hasArchived) async {
    final result = await _client.query$TodoList(
      Options$Query$TodoList(
        variables: Variables$Query$TodoList(archive: hasArchived),
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    return result.parsedData!.todos
        .map(
          (todo) => Todo(
            id: todo.id,
            text: todo.text,
            done: todo.done,
            archived: todo.archived,
            description: todo.description,
          ),
        )
        .toList();
  }

  Future<Todo> getTodo(String id) async {
    final result = await _client.query$TodoDetail(
      Options$Query$TodoDetail(
        variables: Variables$Query$TodoDetail(id: id),
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final todo = result.parsedData!.todo;

    return Todo(
      id: todo.id,
      text: todo.text,
      done: todo.done,
      archived: todo.archived,
      description: todo.description,
    );
  }

  Future<Todo> completeTodo(
    String id,
  ) async {
    final result = await _client.mutate$CompleteTodo(
      Options$Mutation$CompleteTodo(
        variables: Variables$Mutation$CompleteTodo(
          id: id,
        ),
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final todo = result.parsedData!.completeTodo;

    return Todo(
      id: todo.id,
      text: todo.text,
      done: todo.done,
      archived: todo.archived,
      description: todo.description,
    );
  }

  Future<String> archiveTodo(
    String id,
  ) async {
    final result = await _client.mutate$ArchiveTodo(
      Options$Mutation$ArchiveTodo(
        variables: Variables$Mutation$ArchiveTodo(
          id: id,
        ),
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    return result.parsedData!.archiveTodo.id;
  }

  Future<Todo> createTodo(
    Input$CreateTodo input,
  ) async {
    final result = await _client.mutate$CreateTodo(
      Options$Mutation$CreateTodo(
        variables: Variables$Mutation$CreateTodo(
          input: input,
        ),
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final todo = result.parsedData!.createTodo;

    return Todo(
      id: todo.id,
      text: todo.text,
      done: todo.done,
      archived: todo.archived,
      description: todo.description,
    );
  }

  Future<Todo> updateTodo(
    String id,
    Input$UpdateTodo input,
  ) async {
    final result = await _client.mutate$UpdateTodo(
      Options$Mutation$UpdateTodo(
        variables: Variables$Mutation$UpdateTodo(
          id: id,
          input: input,
        ),
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final todo = result.parsedData!.updateTodo;

    return Todo(
      id: todo.id,
      text: todo.text,
      done: todo.done,
      archived: todo.archived,
      description: todo.description,
    );
  }

  Future<String> removeTodo(
    String id,
  ) async {
    final result = await _client.mutate$RemoveTodo(
      Options$Mutation$RemoveTodo(
        variables: Variables$Mutation$RemoveTodo(
          id: id,
        ),
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    return result.parsedData!.removeTodo.id;
  }
}
