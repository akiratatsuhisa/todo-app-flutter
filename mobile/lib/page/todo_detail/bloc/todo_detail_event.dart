part of 'todo_detail_bloc.dart';

class TodoDetailEvent {}

@freezed
class TodoDetailInitialized extends TodoDetailEvent
    with _$TodoDetailInitialized {
  const factory TodoDetailInitialized({required String id}) =
      _TodoDetailInitialized;
}

@freezed
class TodoDetailDoneToggled extends TodoDetailEvent
    with _$TodoDetailDoneToggled {
  const factory TodoDetailDoneToggled() =
      _TodoDetailDoneToggled;
}

@freezed
class TodoDetailArchivedToggled extends TodoDetailEvent
    with _$TodoDetailArchivedToggled {
  const factory TodoDetailArchivedToggled() =
      _TodoDetailArchivedToggled;
}
