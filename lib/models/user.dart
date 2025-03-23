class User {
  final String id;
  final String username;
  final String name;
  final String email;
  final String avatar;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.avatar,
  });

  // Constructor to create a User from a Map (JSON)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  // Convert User to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'avatar': avatar,
    };
  }

  // Copy with method for immutability support
  User copyWith({
    String? id,
    String? username,
    String? name,
    String? email,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }
}
