class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = json;
    if (json['user'] is Map<String, dynamic>) {
      data = json['user'] as Map<String, dynamic>;
    } else if (json['data'] is Map<String, dynamic>) {
      final inner = json['data'] as Map<String, dynamic>;
      data = (inner['user'] is Map<String, dynamic>) ? inner['user'] as Map<String, dynamic> : inner;
    }

    return UserModel(
      id: data['id'] as String? ?? data['_id'] as String? ?? '',
      firstName: data['firstName'] as String? ?? '',
      lastName: data['lastName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
  };
}
