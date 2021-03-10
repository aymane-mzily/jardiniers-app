class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String accessToken;

  User({this.id, this.firstName, this.lastName, this.email, this.accessToken});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      accessToken: json['accessToken'],
    );
  }
}
