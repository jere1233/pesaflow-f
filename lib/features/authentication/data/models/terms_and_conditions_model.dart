// lib/features/authentication/data/models/terms_and_conditions_model.dart

class TermsAndConditionsModel {
  final String id;
  final String body;
  final DateTime createdDate;
  final DateTime updatedDate;

  const TermsAndConditionsModel({
    required this.id,
    required this.body,
    required this.createdDate,
    required this.updatedDate,
  });

  factory TermsAndConditionsModel.fromJson(Map<String, dynamic> json) {
    return TermsAndConditionsModel(
      id: json['id']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'].toString())
          : DateTime.now(),
      updatedDate: json['updatedDate'] != null
          ? DateTime.parse(json['updatedDate'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate.toIso8601String(),
    };
  }

  TermsAndConditionsModel copyWith({
    String? id,
    String? body,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return TermsAndConditionsModel(
      id: id ?? this.id,
      body: body ?? this.body,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }
}