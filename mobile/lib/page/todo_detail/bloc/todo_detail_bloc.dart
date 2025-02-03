import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/interface/failure_state.dart';
import 'package:mobile/model/todo.dart';
import 'package:mobile/repository/todo_repository.dart';

part 'todo_detail_event.dart';
part 'todo_detail_state.dart';

part 'todo_detail_bloc.freezed.dart';

class TodoDetailBloc extends Bloc<TodoDetailEvent, TodoDetailState> {
  final TodoRepository _todoRepository;

  TodoDetailBloc({required TodoRepository todoRepository})
      : _todoRepository = todoRepository,
        super(const TodoDetailInitial()) {
    on<TodoDetailInitialized>(_onTodoDetailInitialized);
    on<TodoDetailDoneToggled>(_onTodoDetailDoneToggled);
    on<TodoDetailArchivedToggled>(_onTodoDetailArchivedToggled);
  }

  Future<void> _onTodoDetailInitialized(
    TodoDetailInitialized event,
    Emitter<TodoDetailState> emit,
  ) async {
    emit(const TodoDetailLoading());

    try {
      final todo = await _todoRepository.getTodo(event.id);

      emit(TodoDetailLoaded(todo: todo));
    } catch (e) {
      emit(const TodoDetailFailure(
        title: "Let's try that again",
        message: "Sorry about that. There was an error submitting content.",
      ));
    }
  }

  Future<void> _onTodoDetailDoneToggled(
    TodoDetailDoneToggled event,
    Emitter<TodoDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TodoDetailLoaded) {
      return;
    }

    try {
      await _todoRepository.completeTodo(currentState.todo.id);

      emit(
        TodoDetailLoaded(
          todo: currentState.todo.copyWith(
            done: !currentState.todo.done,
          ),
        ),
      );
    } catch (e) {
      emit(const TodoDetailFailure(
        title: "Let's try that again",
        message: "Sorry about that. There was an error submitting content.",
      ));
    }
  }

  Future<void> _onTodoDetailArchivedToggled(
    TodoDetailArchivedToggled event,
    Emitter<TodoDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TodoDetailLoaded) {
      return;
    }

    try {
      await _todoRepository.archiveTodo(currentState.todo.id);

      emit(
        TodoDetailLoaded(
          todo: currentState.todo.copyWith(
            archived: !currentState.todo.archived,
          ),
        ),
      );
    } catch (e) {
      emit(const TodoDetailFailure(
        title: "Let's try that again",
        message: "Sorry about that. There was an error submitting content.",
      ));
    }
  }
}
