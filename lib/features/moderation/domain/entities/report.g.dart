// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Report _$ReportFromJson(Map<String, dynamic> json) => _Report(
  id: json['id'] as String,
  reporterId: json['reporterId'] as String,
  reportedId: json['reportedId'] as String,
  reason: json['reason'] as String,
  details: json['details'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ReportToJson(_Report instance) => <String, dynamic>{
  'id': instance.id,
  'reporterId': instance.reporterId,
  'reportedId': instance.reportedId,
  'reason': instance.reason,
  'details': instance.details,
  'createdAt': instance.createdAt.toIso8601String(),
};
