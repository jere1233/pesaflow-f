///home/hp/JERE/pension-frontend/lib/features/authentication/data/models/login_response_model.dart

class LoginResponseModel {
  final bool success;
  final String? message;
  final bool? temporary; // Indicates if user needs to set permanent password
  final String? identifier;

  LoginResponseModel({
    required this.success,
    this.message,
    this.temporary,
    this.identifier,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString(),
      temporary: json['temporary'] == true,
      identifier: json['identifier']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (message != null) 'message': message,
      if (temporary != null) 'temporary': temporary,
      if (identifier != null) 'identifier': identifier,
    };
  }
}