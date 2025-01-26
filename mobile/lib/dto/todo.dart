import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';

@freezed
class TodoDto with _$TodoDto {
  const factory TodoDto({
    required String id,
    required String text,
    required bool done,
    required bool archived,
    String? description,
  }) = _TodoDto;
}
