part of 'todo_bottom_nav_bar_cubit.dart';

@freezed
class TodoBottomNavBarState with _$TodoBottomNavBarState {
  const factory TodoBottomNavBarState({
    @Default(0) int currentIndex,
  }) = _TodoBottomNavBarState;
}
