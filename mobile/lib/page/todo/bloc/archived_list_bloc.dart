import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/dto/todo.dart';
import 'package:mobile/interface/failure_state.dart';
import 'package:mobile/repository/todo_repository.dart';

part 'archived_list_event.dart';
part 'archived_list_state.dart';

part 'archived_list_bloc.freezed.dart';

class ArchivedListBloc extends Bloc<ArchivedListEvent, ArchivedListState> {
  final TodoRepository _todoRepository;

  ArchivedListBloc({required TodoRepository todoRepository})
      : _todoRepository = todoRepository,
        super(const ArchivedListInitial()) {
    on<ArchivedListDataFetched>(_onArchivedListDataFetched);
    on<ArchivedListItemToggleArchived>(_onArchivedListItemToggleArchived);
  }

  Future<void> _onArchivedListDataFetched(
    ArchivedListDataFetched event,
    Emitter<ArchivedListState> emit,
  ) async {
    emit(const ArchivedListLoading());

    try {
      final todos = await _todoRepository.getTodos(true);
      emit(ArchivedListSuccess(items: todos));
    } catch (e) {
      emit(
        const ArchivedListFailure(
          title: "Let's try that again",
          message: "Sorry about that. There was an error loading content.",
        ),
      );
    }
  }

  Future<void> _onArchivedListItemToggleArchived(
    ArchivedListItemToggleArchived event,
    Emitter<ArchivedListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ArchivedListSuccess) {
      return;
    }

    try {
      final removedId = await _todoRepository.archiveTodo(event.id);

      emit(
        ArchivedListSuccess(
          items:
              currentState.items.where((item) => item.id != removedId).toList(),
        ),
      );
    } catch (e) {
      emit(
        const ArchivedListFailure(
          title: "Let's try that again",
          message: "Sorry about that. There was an error loading content.",
        ),
      );
    }
  }
}
