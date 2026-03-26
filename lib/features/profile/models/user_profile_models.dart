class UserProfileModels {
  UserProfileModels({
    required this.company,
    required this.email,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.role,
  });

  final Company? company;
  final String? email;
  final String? employeeId;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;
  final String? role;

  factory UserProfileModels.fromJson(Map<String, dynamic> json) {
    return UserProfileModels(
      company: json["company"] == null
          ? null
          : Company.fromJson(json["company"]),
      email: json["email"],
      employeeId: json["employee_id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      profilePicture: json["profile_picture"],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() => {
    "company": company?.toJson(),
    "email": email,
    "employee_id": employeeId,
    "first_name": firstName,
    "last_name": lastName,
    "profile_picture": profilePicture,
    "role": role,
  };
}

class Company {
  Company({required this.companyCode, required this.companyName});

  final String? companyCode;
  final String? companyName;

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyCode: json["company_code"],
      companyName: json["company_name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "company_code": companyCode,
    "company_name": companyName,
  };
}
