import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/model/input/todo_input.dart';
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
    on<TodoSaveFieldChanged>(_onTodoSaveFieldChanged);
  }

  Future<void> _onTodoSaveInitialized(
    TodoSaveInitialized event,
    Emitter<TodoSaveState> emit,
  ) async {
    emit(const TodoSaveLoading());

    if (event.id != null) {
      final todo = await _todoRepository.getTodo(event.id!);
      emit(
        TodoSaveInProgress(
          text: TodoText.pure(todo.text),
          description: TodoDescription.pure(todo.description),
        ),
      );
    } else {
      emit(const TodoSaveInProgress());
    }
  }

  Future<void> _onTodoSaveSubmitted(
    TodoSaveSubmitted event,
    Emitter<TodoSaveState> emit,
  ) async {
    final currentState = state;

    if (currentState is! TodoSaveInProgress) {
      return;
    }

    emit(const TodoSaveLoading());

    if (!Formz.validate([currentState.text, currentState.description])) {
      emit(
        currentState.copyWith(
          text: TodoText.dirty(currentState.text.value),
          description: TodoDescription.dirty(currentState.description.value),
        ),
      );
      return;
    }

    try {
      final Todo todo;
      if (event.id == null) {
        todo = await _todoRepository.createTodo(
          Input$CreateTodo(
            text: currentState.text.value,
            description: currentState.description.value,
          ),
        );
      } else {
        todo = await _todoRepository.updateTodo(
          event.id!,
          Input$UpdateTodo(
            text: currentState.text.value,
            description: currentState.description.value,
          ),
        );
      }
      emit(TodoSaveSuccess(todo: todo));
      emit(currentState.copyWith());
    } catch (e) {
      emit(const TodoSaveFailure(
        title: "Let's try that again",
        message: "Sorry about that. There was an error submitting content.",
      ));
    }
  }

  void _onTodoSaveFieldChanged(
    TodoSaveFieldChanged event,
    Emitter<TodoSaveState> emit,
  ) {
    final currentState = state;

    if (currentState is! TodoSaveInProgress) {
      return;
    }

    if (event.field == 'text') {
      emit(currentState.copyWith(text: TodoText.dirty(event.value)));
    } else {
      emit(
        currentState.copyWith(description: TodoDescription.dirty(event.value)),
      );
    }
  }
}
