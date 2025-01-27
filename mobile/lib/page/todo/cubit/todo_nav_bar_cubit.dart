import 'package:flutter_bloc/flutter_bloc.dart';

class TodoNavBarCubit extends Cubit<int> {
  TodoNavBarCubit() : super(0);

  void setIndex(int value) {
    emit(value);
  }
}
