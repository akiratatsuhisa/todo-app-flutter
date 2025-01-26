import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile/dto/todo.dart';
import 'package:mobile/graphql/scheme.graphql.dart';
import 'package:mobile/graphql/todo/archive.graphql.dart';
import 'package:mobile/graphql/todo/complete.graphql.dart';
import 'package:mobile/graphql/todo/create.graphql.dart';
import 'package:mobile/graphql/todo/list.graphql.dart';
import 'package:mobile/graphql/todo/remove.graphql.dart';
import 'package:mobile/graphql/todo/update.graphql.dart';

class TodoRepository {
  final GraphQLClient client;

  TodoRepository({required this.client});

  Future<List<TodoDto>> getTodos(bool? hasArchived) async {
    final result = await client.query$TodoList(
      Options$Query$TodoList(
        variables: Variables$Query$TodoList(archive: hasArchived),
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    return result.parsedData!.todos
        .map(
          (todo) => TodoDto(
            id: todo.id,
            text: todo.text,
            done: todo.done,
            archived: todo.archived,
            description: todo.description,
          ),
        )
        .toList();
  }

  Future<TodoDto> completeTodo(
    String id,
  ) async {
    final result = await client.mutate$CompleteTodo(
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

    return TodoDto(
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
    final result = await client.mutate$ArchiveTodo(
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

  Future<TodoDto> createTodo(
    Input$CreateTodo input,
  ) async {
    final result = await client.mutate$CreateTodo(
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

    return TodoDto(
      id: todo.id,
      text: todo.text,
      done: todo.done,
      archived: todo.archived,
      description: todo.description,
    );
  }

  Future<TodoDto> updateTodo(
    String id,
    Input$UpdateTodo input,
  ) async {
    final result = await client.mutate$UpdateTodo(
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

    return TodoDto(
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
    final result = await client.mutate$RemoveTodo(
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
