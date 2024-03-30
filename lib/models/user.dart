import 'dart:convert';

class UserData {
  final String uuid;
  final String firstName;
  final String lastName;
  final String email;
  final String birthday;

  UserData({
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.birthday,
  });

  UserData copyWith({
    String? uuid,
    String? firstName,
    String? lastName,
    String? email,
    String? birthday,
  }) {
    return UserData(
      uuid: uuid ?? this.uuid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      birthday: birthday ?? this.birthday,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'birthday': birthday,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uuid: map['uuid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      birthday: map['birthday'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserData(uuid: $uuid, firstName: $firstName, lastName: $lastName, email: $email, birthday: $birthday)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData &&
        other.uuid == uuid &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.birthday == birthday;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        birthday.hashCode;
  }
}
