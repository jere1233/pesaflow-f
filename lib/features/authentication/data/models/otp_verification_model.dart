///home/hp/JERE/pension-frontend/lib/features/authentication/data/models/otp_verification_model.dart
class OtpVerificationModel {
  final String identifier; 
  final String otp;
  final String verificationType;

  const OtpVerificationModel({
    required this.identifier,
    required this.otp,
    required this.verificationType,
  });

  factory OtpVerificationModel.fromJson(Map<String, dynamic> json) {
    return OtpVerificationModel(
      identifier: json['identifier']?.toString() ?? 
                  json['phone_number']?.toString() ?? 
                  json['phoneNumber']?.toString() ?? 
                  json['email']?.toString() ?? '',
      otp: json['otp']?.toString() ?? '',
      verificationType: json['verification_type']?.toString() ?? 
                        json['verificationType']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'otp': otp,
      'verificationType': verificationType,
    };
  }
}
