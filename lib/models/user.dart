// models/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String userType;
  final String? contactNumber;
  final String? specialization;
  final String? hospitalId;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.contactNumber,
    this.specialization,
    this.hospitalId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'userType': userType,
      'contactNumber': contactNumber,
      'specialization': specialization,
      'hospitalId': hospitalId,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      userType: json['userType'],
      contactNumber: json['contactNumber'],
      specialization: json['specialization'],
      hospitalId: json['hospitalId'],
    );
  }
}