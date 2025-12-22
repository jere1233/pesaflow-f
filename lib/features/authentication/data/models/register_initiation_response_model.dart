class RegisterInitiationResponseModel {
  final bool success;
  final String status;
  final String? message;
  final String? transactionId;
  final String? checkoutRequestId;
  final String? statusCheckUrl;

  RegisterInitiationResponseModel({
    required this.success,
    required this.status,
    this.message,
    this.transactionId,
    this.checkoutRequestId,
    this.statusCheckUrl,
  });

  factory RegisterInitiationResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterInitiationResponseModel(
      success: json['success'] == true || json['success']?.toString() == 'true',
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString(),
      transactionId: json['transactionId']?.toString() ?? json['transaction_id']?.toString(),
      checkoutRequestId: json['checkoutRequestId']?.toString() ?? json['checkout_request_id']?.toString(),
      statusCheckUrl: json['statusCheckUrl']?.toString() ?? json['status_check_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      if (message != null) 'message': message,
      if (transactionId != null) 'transactionId': transactionId,
      if (checkoutRequestId != null) 'checkoutRequestId': checkoutRequestId,
      if (statusCheckUrl != null) 'statusCheckUrl': statusCheckUrl,
    };
  }
}
