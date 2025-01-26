part of 'todo_list_bloc.dart';

class TodoListEvent {}

@freezed
class TodoListDataFetched extends TodoListEvent with _$TodoListDataFetched {
  const factory TodoListDataFetched() = _TodoListDataFetched;
}

@freezed
class TodoListItemToggleCompleted extends TodoListEvent
    with _$TodoListItemToggleCompleted {
  const factory TodoListItemToggleCompleted({required String id}) =
      _TodoListItemToggleCompleted;
}

@freezed
class TodoListItemToggleArchived extends TodoListEvent
    with _$TodoListItemToggleArchived {
  const factory TodoListItemToggleArchived({required String id}) =
      _TodoListItemToggleArchived;
}

@freezed
class TodoListItemRemoved extends TodoListEvent with _$TodoListItemRemoved {
  const factory TodoListItemRemoved({required String id}) =
      _TodoListItemRemoved;
}
