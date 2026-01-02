// lib/features/reports/domain/entities/report.dart

import 'package:equatable/equatable.dart';

class Report extends Equatable {
  final String id;
  final String type;
  final String title;
  final String fileName;
  final String pdfBase64;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const Report({
    required this.id,
    required this.type,
    required this.title,
    required this.fileName,
    required this.pdfBase64,
    this.metadata,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        fileName,
        pdfBase64,
        metadata,
        createdAt,
      ];

  Report copyWith({
    String? id,
    String? type,
    String? title,
    String? fileName,
    String? pdfBase64,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return Report(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      fileName: fileName ?? this.fileName,
      pdfBase64: pdfBase64 ?? this.pdfBase64,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}