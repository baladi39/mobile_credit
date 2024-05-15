import 'package:mobile_credit/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.isVerifed,
  });

  /// Not needed since we are not receiving any json.
  ///
  // factory UserModel.fromJson(Map<String, dynamic> map) {
  //   return UserModel(
  //     id: map['id'] ?? '',
  //     email: map['email'] ?? '',
  //     name: map['name'] ?? '',
  //     isVerifed: map['is_verifed'] ?? '',
  //   );
  // }

  // UserModel copyWith({
  //   int? id,
  //   String? email,
  //   String? name,
  //   bool? isVerifed,
  // }) {
  //   return UserModel(
  //     id: id ?? this.id,
  //     email: email ?? this.email,
  //     name: name ?? this.name,
  //     isVerifed: isVerifed ?? this.isVerifed,
  //   );
  // }
}
