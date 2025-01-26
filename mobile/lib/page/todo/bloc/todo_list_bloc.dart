import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/dto/todo.dart';
import 'package:mobile/interface/error_state.dart';
import 'package:mobile/repository/todo_repository.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';
part 'todo_list_bloc.freezed.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final TodoRepository todoRepository;

  TodoListBloc({required this.todoRepository})
      : super(const TodoListInitial()) {
    on<TodoListDataFetched>(_onTodoListDataFetched);
    on<TodoListItemToggleCompleted>(_onTodoListItemToggleCompleted);
    on<TodoListItemToggleArchived>(_onTodoListItemToggleArchived);
    on<TodoListItemRemoved>(_onTodoListItemRemoved);
  }

  Future<void> _onTodoListDataFetched(
    TodoListDataFetched event,
    Emitter<TodoListState> emit,
  ) async {
    emit(const TodoListLoading());

    await Future.delayed(const Duration(seconds: 2));

    try {
      final todos = await todoRepository.getTodos(false);
      emit(TodoListSuccess(items: todos));
    } catch (e) {
      emit(
        const TodoListFailure(
          message:
              'An unexpected error occurred while attempting to fetch the todo list.',
        ),
      );
    }
  }

  Future<void> _onTodoListItemToggleCompleted(
    TodoListItemToggleCompleted event,
    Emitter<TodoListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TodoListSuccess) {
      return;
    }

    try {
      final todo = await todoRepository.completeTodo(event.id);

      emit(
        TodoListSuccess(
          items: currentState.items
              .map((item) => item.id != todo.id ? item : todo)
              .toList(),
        ),
      );
    } catch (e) {
      emit(
        const TodoListFailure(
          message:
              'An unexpected error occurred while attempting to fetch the todo list.',
        ),
      );
    }
  }

  Future<void> _onTodoListItemToggleArchived(
    TodoListItemToggleArchived event,
    Emitter<TodoListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TodoListSuccess) {
      return;
    }

    try {
      final removedId = await todoRepository.archiveTodo(event.id);

      emit(
        TodoListSuccess(
          items:
              currentState.items.where((item) => item.id != removedId).toList(),
        ),
      );
    } catch (e) {
      emit(
        const TodoListFailure(
          message:
              'An unexpected error occurred while attempting to fetch the todo list.',
        ),
      );
    }
  }

  Future<void> _onTodoListItemRemoved(
    TodoListItemRemoved event,
    Emitter<TodoListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TodoListSuccess) {
      return;
    }

    try {
      final archivedId = await todoRepository.archiveTodo(event.id);

      emit(
        TodoListSuccess(
          items: currentState.items
              .where((item) => item.id != archivedId)
              .toList(),
        ),
      );
    } catch (e) {
      emit(
        const TodoListFailure(
          message:
              'An unexpected error occurred while attempting to fetch the todo list.',
        ),
      );
    }
  }
}
