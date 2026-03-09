import 'package:freezed_annotation/freezed_annotation.dart';

part 'block.freezed.dart';
part 'block.g.dart';

@freezed
abstract class Block with _$Block {
  const factory Block({
    required String id,
    required String blockerId,
    required String blockedId,
    required DateTime createdAt,
  }) = _Block;

  factory Block.fromJson(Map<String, dynamic> json) =>
      _$BlockFromJson(json);
}
