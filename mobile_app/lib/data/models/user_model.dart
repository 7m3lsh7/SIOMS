class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatar;
  final List<String> permissions;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    required this.permissions,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      role: json['role'],
      avatar: json['avatar'],
      permissions: List<String>.from(json['permissions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'avatar': avatar,
      'permissions': permissions,
    };
  }
}
