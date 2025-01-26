import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_bottom_nav_bar_state.dart';

part 'todo_bottom_nav_bar_cubit.freezed.dart';

class TodoBottomNavBarCubit extends Cubit<TodoBottomNavBarState> {
  TodoBottomNavBarCubit() : super(const TodoBottomNavBarState());

  void setTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
