import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/model/todo.dart';
import 'package:mobile/graphql/scheme.graphql.dart';
import 'package:mobile/interface/failure_state.dart';
import 'package:mobile/repository/todo_repository.dart';

part 'todo_save_event.dart';
part 'todo_save_state.dart';

part 'todo_save_bloc.freezed.dart';

class TodoSaveBloc extends Bloc<TodoSaveEvent, TodoSaveState> {
  final TodoRepository _todoRepository;

  TodoSaveBloc({required TodoRepository todoRepository})
      : _todoRepository = todoRepository,
        super(const TodoSaveInitial()) {
    on<TodoSaveInitialized>(_onTodoSaveInitialized);
    on<TodoSaveSubmitted>(_onTodoSaveSubmitted);
  }

  Future<void> _onTodoSaveInitialized(
    TodoSaveInitialized event,
    Emitter<TodoSaveState> emit,
  ) async {
    emit(const TodoSaveLoading());

    if (event.id != null) {
      final todo = await _todoRepository.getTodo(event.id!);
      emit(TodoSaveLoaded(todo: todo));
    }
    emit(const TodoSaveInProgress());
  }

  Future<void> _onTodoSaveSubmitted(
    TodoSaveSubmitted event,
    Emitter<TodoSaveState> emit,
  ) async {
    emit(const TodoSaveLoading());

    try {
      final Todo todo;
      if (event.id == null) {
        todo = await _todoRepository.createTodo(
          Input$CreateTodo(
            text: event.text,
            description: event.description,
          ),
        );
      } else {
        todo = await _todoRepository.updateTodo(
          event.id!,
          Input$UpdateTodo(
            text: event.text,
            description: event.description,
          ),
        );
      }
      emit(TodoSaveSuccess(todo: todo));
      emit(const TodoSaveInProgress());
    } catch (e) {
      emit(const TodoSaveFailure(
        title: "Let's try that again",
        message: "Sorry about that. There was an error submitting content.",
      ));
    }
  }
}
