part of 'todo_list_bloc.dart';

sealed class TodoListEvent {}

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
class TodoListItemAdded extends TodoListEvent with _$TodoListItemAdded {
  const factory TodoListItemAdded({required TodoDto todo}) = _TodoListItemAdded;
}

@freezed
class TodoListItemUpdated extends TodoListEvent with _$TodoListItemUpdated {
  const factory TodoListItemUpdated({required TodoDto todo}) =
      _TodoListItemUpdated;
}

@freezed
class TodoListItemRemoved extends TodoListEvent with _$TodoListItemRemoved {
  const factory TodoListItemRemoved({required String id}) =
      _TodoListItemRemoved;
}
