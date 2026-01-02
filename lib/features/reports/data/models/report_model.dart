// lib/features/reports/data/models/report_model.dart

import '../../domain/entities/report.dart';

class ReportModel extends Report {
  const ReportModel({
    required super.id,
    required super.type,
    required super.title,
    required super.fileName,
    required super.pdfBase64,
    super.metadata,
    required super.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      fileName: json['fileName'] ?? '',
      pdfBase64: json['pdfBase64'] ?? '',
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'fileName': fileName,
      'pdfBase64': pdfBase64,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Report toEntity() {
    return Report(
      id: id,
      type: type,
      title: title,
      fileName: fileName,
      pdfBase64: pdfBase64,
      metadata: metadata,
      createdAt: createdAt,
    );
  }
}