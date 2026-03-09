import 'package:freezed_annotation/freezed_annotation.dart';

part 'report.freezed.dart';
part 'report.g.dart';

@freezed
abstract class Report with _$Report {
  const factory Report({
    required String id,
    required String reporterId,
    required String reportedId,
    required String reason,
    String? details,
    required DateTime createdAt,
  }) = _Report;

  factory Report.fromJson(Map<String, dynamic> json) =>
      _$ReportFromJson(json);
}
