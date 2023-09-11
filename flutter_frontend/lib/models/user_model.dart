import 'dart:ffi';

class UserModel {
  final bool EmailVerified;
  final bool Disabled;
  final String Name;
  final String Role;
  final String Email;
  final String UID;

  const UserModel({
    this.EmailVerified = false,
    this.Disabled = false,
    this.Name = "",
    this.Role = "",
    this.Email = "",
    this.UID = "",
  });

  factory UserModel.fromJson(Map json) {
    return UserModel(
      EmailVerified: json['EmailVerified'],
      Disabled: json['Disabled'],
      Name: json['Name'],
      Role: json['Role'],
      Email: json['Email'],
      UID: json['UID'],
    );
  }
}
