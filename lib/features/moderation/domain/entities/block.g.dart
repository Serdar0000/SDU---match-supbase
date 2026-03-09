// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Block _$BlockFromJson(Map<String, dynamic> json) => _Block(
  id: json['id'] as String,
  blockerId: json['blockerId'] as String,
  blockedId: json['blockedId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BlockToJson(_Block instance) => <String, dynamic>{
  'id': instance.id,
  'blockerId': instance.blockerId,
  'blockedId': instance.blockedId,
  'createdAt': instance.createdAt.toIso8601String(),
};
