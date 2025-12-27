///home/hp/JERE/pension-frontend/lib/features/authentication/data/models/register_request_model.dart

class RegisterRequestModel {
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final String? dateOfBirth;
  final String? gender;
  final String? maritalStatus;
  final String? spouseName;
  final String? spouseDob;
  final List<ChildModel>? children;
  final String? nationalId;
  final String? address;
  final String? city;
  final String? country;
  final String? occupation;
  final String? employer;
  final num? salary;
  final num? contributionRate;
  final int? retirementAge;
  
  // 🆕 NEW: Backend-supported fields
  final String? accountType; // MANDATORY, VOLUNTARY, EMPLOYER, SAVINGS, WITHDRAWAL, BENEFITS
  final String? riskProfile; // LOW, MEDIUM, HIGH
  final String? currency; // KES, USD, etc.
  final String? accountStatus; // ACTIVE, SUSPENDED, CLOSED, FROZEN, DECEASED
  final bool? kycVerified;
  final String? complianceStatus; // PENDING, APPROVED, REJECTED, SUSPENDED
  final String? pin; // Optional 4-digit PIN

  const RegisterRequestModel({
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    this.gender,
    this.maritalStatus,
    this.spouseName,
    this.spouseDob,
    this.children,
    this.nationalId,
    this.address,
    this.city,
    this.country,
    this.occupation,
    this.employer,
    this.salary,
    this.contributionRate,
    this.retirementAge,
    this.accountType,
    this.riskProfile,
    this.currency,
    this.accountStatus,
    this.kycVerified,
    this.complianceStatus,
    this.pin,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    List<ChildModel>? parsedChildren;
    if (json['children'] is List) {
      parsedChildren = (json['children'] as List)
          .map((e) => ChildModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return RegisterRequestModel(
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? json['phone_number']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? json['first_name']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? json['last_name']?.toString() ?? '',
      dateOfBirth: json['dateOfBirth']?.toString() ?? json['date_of_birth']?.toString(),
      gender: json['gender']?.toString(),
      maritalStatus: json['maritalStatus']?.toString() ?? json['marital_status']?.toString(),
      spouseName: json['spouseName']?.toString() ?? json['spouse_name']?.toString(),
      spouseDob: json['spouseDob']?.toString() ?? json['spouse_dob']?.toString(),
      children: parsedChildren,
      nationalId: json['nationalId']?.toString() ?? json['national_id']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      country: json['country']?.toString(),
      occupation: json['occupation']?.toString(),
      employer: json['employer']?.toString(),
      salary: json['salary'],
      contributionRate: json['contributionRate'] ?? json['contribution_rate'],
      retirementAge: json['retirementAge'] ?? json['retirement_age'],
      accountType: json['accountType']?.toString() ?? json['account_type']?.toString(),
      riskProfile: json['riskProfile']?.toString() ?? json['risk_profile']?.toString(),
      currency: json['currency']?.toString(),
      accountStatus: json['accountStatus']?.toString() ?? json['account_status']?.toString(),
      kycVerified: json['kycVerified'] ?? json['kyc_verified'],
      complianceStatus: json['complianceStatus']?.toString() ?? json['compliance_status']?.toString(),
      pin: json['pin']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      if (gender != null) 'gender': gender,
      if (maritalStatus != null) 'maritalStatus': maritalStatus,
      if (spouseName != null) 'spouseName': spouseName,
      if (spouseDob != null) 'spouseDob': spouseDob,
      if (children != null) 'children': children!.map((c) => c.toJson()).toList(),
      if (nationalId != null) 'nationalId': nationalId,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (occupation != null) 'occupation': occupation,
      if (employer != null) 'employer': employer,
      if (salary != null) 'salary': salary,
      if (contributionRate != null) 'contributionRate': contributionRate,
      if (retirementAge != null) 'retirementAge': retirementAge,
      if (accountType != null) 'accountType': accountType,
      if (riskProfile != null) 'riskProfile': riskProfile,
      if (currency != null) 'currency': currency,
      if (accountStatus != null) 'accountStatus': accountStatus,
      if (kycVerified != null) 'kycVerified': kycVerified,
      if (complianceStatus != null) 'complianceStatus': complianceStatus,
      if (pin != null) 'pin': pin,
    };
  }
}

class ChildModel {
  final String name;
  final String dob;

  ChildModel({required this.name, required this.dob});

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      name: json['name']?.toString() ?? '',
      dob: json['dob']?.toString() ?? json['dateOfBirth']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dob': dob,
    };
  }
}