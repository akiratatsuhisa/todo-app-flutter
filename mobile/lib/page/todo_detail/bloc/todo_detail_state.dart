part of 'todo_detail_bloc.dart';

class TodoDetailState {}

@freezed
class TodoDetailInitial extends TodoDetailState with _$TodoDetailInitial {
  const factory TodoDetailInitial() = _TodoDetailInitial;
}

@freezed
class TodoDetailLoading extends TodoDetailState with _$TodoDetailLoading {
  const factory TodoDetailLoading() = _TodoDetailLoading;
}

@freezed
class TodoDetailLoaded extends TodoDetailState with _$TodoDetailLoaded {
  const factory TodoDetailLoaded({
    required Todo todo,
  }) = _TodoDetailLoaded;
}

@freezed
class TodoDetailFailure extends TodoDetailState
    with _$TodoDetailFailure
    implements FailureState {
  const factory TodoDetailFailure({
    required String title,
    required String message,
  }) = _TodoDetailFailure;
}
