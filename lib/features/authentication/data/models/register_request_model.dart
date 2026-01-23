class RegisterRequestModel {
  // Required fields
  final String email;
  final String phone;
  final String? pin; // NOW OPTIONAL
  
  // Bank account details (OPTIONAL)
  final String? bankAccountName;
  final String? bankAccountNumber;
  final String? bankBranchName;
  final String? bankBranchCode;
  final String? bankName; 
  
  // Personal information
  final String? firstName;
  final String? lastName;
  final String? dateOfBirth;
  final String? gender;
  final String? maritalStatus;
  final String? spouseName;
  final String? spouseDob;
  final List<ChildModel>? children;
  final String? nationalId;
  
  // Address
  final String? address;
  final String? city;
  final String? country;
  
  // Employment
  final String? occupation;
  final String? employer;
  final num? salary;
  
  // Pension details
  final num? contributionRate;
  final int? retirementAge;
  final String accountType;
  final String riskProfile;
  final String currency;
  final String accountStatus;
  final bool kycVerified;
  final String complianceStatus;

  const RegisterRequestModel({
    required this.email,
    required this.phone,
    this.pin, // NOW OPTIONAL
    this.bankAccountName,
    this.bankAccountNumber,
    this.bankBranchName,
    this.bankBranchCode,
    this.bankName,
    this.firstName,
    this.lastName,
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
    this.accountType = 'MANDATORY',
    this.riskProfile = 'MEDIUM',
    this.currency = 'KES',
    this.accountStatus = 'ACTIVE',
    this.kycVerified = false,
    this.complianceStatus = 'PENDING',
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
      phone: json['phone']?.toString() ?? '',
      pin: json['pin']?.toString(), // NOW OPTIONAL
      bankAccountName: json['bankAccountName']?.toString(),
      bankAccountNumber: json['bankAccountNumber']?.toString(),
      bankBranchName: json['bankBranchName']?.toString(),
      bankBranchCode: json['bankBranchCode']?.toString(),
      bankName: json['bankName']?.toString(), // 🆕 NEW FIELD
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      dateOfBirth: json['dateOfBirth']?.toString(),
      gender: json['gender']?.toString(),
      maritalStatus: json['maritalStatus']?.toString(),
      spouseName: json['spouseName']?.toString(),
      spouseDob: json['spouseDob']?.toString(),
      children: parsedChildren,
      nationalId: json['nationalId']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      country: json['country']?.toString(),
      occupation: json['occupation']?.toString(),
      employer: json['employer']?.toString(),
      salary: json['salary'],
      contributionRate: json['contributionRate'],
      retirementAge: json['retirementAge'],
      accountType: json['accountType']?.toString() ?? 'MANDATORY',
      riskProfile: json['riskProfile']?.toString() ?? 'MEDIUM',
      currency: json['currency']?.toString() ?? 'KES',
      accountStatus: json['accountStatus']?.toString() ?? 'ACTIVE',
      kycVerified: json['kycVerified'] ?? false,
      complianceStatus: json['complianceStatus']?.toString() ?? 'PENDING',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      if (pin != null && pin!.isNotEmpty) 'pin': pin, // ONLY SEND IF PROVIDED
      if (bankAccountName != null) 'bankAccountName': bankAccountName,
      if (bankAccountNumber != null) 'bankAccountNumber': bankAccountNumber,
      if (bankBranchName != null) 'bankBranchName': bankBranchName,
      if (bankBranchCode != null) 'bankBranchCode': bankBranchCode,
      if (bankName != null) 'bankName': bankName,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
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
      'accountType': accountType,
      'riskProfile': riskProfile,
      'currency': currency,
      'accountStatus': accountStatus,
      'kycVerified': kycVerified,
      'complianceStatus': complianceStatus,
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