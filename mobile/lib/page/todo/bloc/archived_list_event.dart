part of 'archived_list_bloc.dart';

class ArchivedListEvent {}

@freezed
class ArchivedListDataFetched extends ArchivedListEvent
    with _$ArchivedListDataFetched {
  const factory ArchivedListDataFetched() = _ArchivedListDataFetched;
}

@freezed
class ArchivedListItemToggleArchived extends ArchivedListEvent
    with _$ArchivedListItemToggleArchived {
  const factory ArchivedListItemToggleArchived({required String id}) =
      _ArchivedListItemToggleArchived;
}
