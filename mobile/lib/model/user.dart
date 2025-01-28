import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    String? email,
    String? name,
    String? photo,
  }) = _User;

  static const empty = User(id: '');
}
