import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/model/todo.dart';
import 'package:mobile/interface/failure_state.dart';
import 'package:mobile/repository/todo_repository.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';
part 'todo_list_bloc.freezed.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final TodoRepository _todoRepository;

  TodoListBloc({required TodoRepository todoRepository})
      : _todoRepository = todoRepository,
        super(const TodoListInitial()) {
    on<TodoListDataFetched>(_onTodoListDataFetched);
    on<TodoListItemToggleCompleted>(_onTodoListItemToggleCompleted);
    on<TodoListItemToggleArchived>(_onTodoListItemToggleArchived);
    on<TodoListItemAdded>(_onTodoListItemAdded);
    on<TodoListItemUpdated>(_onTodoListItemUpdated);
    on<TodoListItemRemoved>(_onTodoListItemRemoved);
  }

  Future<void> _onTodoListDataFetched(
    TodoListDataFetched event,
    Emitter<TodoListState> emit,
  ) async {
    emit(const TodoListLoading());

    try {
      final todos = await _todoRepository.getTodos(false);
      emit(TodoListSuccess(items: todos));
    } catch (e) {
      emit(
        const TodoListFailure(
          title: "Let's try that again",
          message: "Sorry about that. There was an error loading content.",
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
      final todo = await _todoRepository.completeTodo(event.id);

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
          title: "Let's try that again",
          message: "Sorry about that. There was an error loading content.",
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
      final removedId = await _todoRepository.archiveTodo(event.id);

      emit(
        TodoListSuccess(
          items:
              currentState.items.where((item) => item.id != removedId).toList(),
        ),
      );
    } catch (e) {
      emit(
        const TodoListFailure(
          title: "Let's try that again",
          message: "Sorry about that. There was an error loading content.",
        ),
      );
    }
  }

  void _onTodoListItemAdded(
    TodoListItemAdded event,
    Emitter<TodoListState> emit,
  ) {
    final currentState = state;
    if (currentState is! TodoListSuccess) {
      return;
    }

    emit(
      TodoListSuccess(
        items: currentState.items.toList()..add(event.todo),
      ),
    );
  }

  void _onTodoListItemUpdated(
    TodoListItemUpdated event,
    Emitter<TodoListState> emit,
  ) {
    final currentState = state;
    if (currentState is! TodoListSuccess) {
      return;
    }

    emit(
      TodoListSuccess(
        items: currentState.items
            .map(
              (item) => item.id == event.todo.id ? event.todo : item,
            )
            .toList(),
      ),
    );
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
      final archivedId = await _todoRepository.archiveTodo(event.id);

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
          title: "Let's try that again",
          message: "Sorry about that. There was an error loading content.",
        ),
      );
    }
  }
}
