part of 'todo_list_bloc.dart';

class TodoListState {}

@freezed
class TodoListInitial extends TodoListState with _$TodoListInitial {
  const factory TodoListInitial() = _TodoListInitial;
}

@freezed
class TodoListLoading extends TodoListState with _$TodoListLoading {
  const factory TodoListLoading() = _TodoListLoading;
}

@freezed
class TodoListSuccess extends TodoListState with _$TodoListSuccess {
  const factory TodoListSuccess({required List<TodoDto> items}) =
      _TodoListSuccess;
}

@freezed
class TodoListFailure extends TodoListState
    with _$TodoListFailure
    implements ErrorState {
  const factory TodoListFailure({required String message}) = _TodoListError;
}
