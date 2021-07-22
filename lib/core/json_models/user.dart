import 'package:slot_service_app/core/models/user.dart';

class JsonUser {
  final String firstname;
  final String lastname;
  final String role;

  JsonUser({
    required this.firstname,
    required this.lastname,
    required this.role,
  });

  factory JsonUser.fromUser(User user) {
    return JsonUser(
      firstname: user.firstname,
      lastname: user.lastname,
      role: user.role.toString(),
    );
  }

  factory JsonUser.fromJson(Map<String, dynamic> json) {
    return JsonUser(
      firstname: json['firstname'],
      lastname: json['lastname'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'role': role,
    };
  }

  User toUser() {
    return User(
      firstname: firstname,
      lastname: lastname,
      role: _toUserRole(role),
    );
  }

  UserRole _toUserRole(String role) {
    switch(role.toUpperCase()) {
      case 'ADMIN':
        return UserRole.ADMIN;
      default:
        return UserRole.EMPLOYEE;
    }
  }
}
