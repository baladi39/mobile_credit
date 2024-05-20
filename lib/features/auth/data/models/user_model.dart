import 'package:mobile_credit/core/common/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.isVerifed,
  });

  // Methods for converting to and from JSON format, currently not used due to mocked responses.
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['user_id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      isVerifed: map['is_verifed'] ?? '',
    );
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? name,
    bool? isVerifed,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      isVerifed: isVerifed ?? this.isVerifed,
    );
  }
}
