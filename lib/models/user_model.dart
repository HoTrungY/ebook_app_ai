class User {
  final String id;
  final String username;
  final bool isLoggedIn;

  User({
    required this.id,
    required this.username,
    this.isLoggedIn = false,
  });

  User copyWith({String? id, String? username, bool? isLoggedIn}) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  factory User.empty() {
    return User(
      id: '',
      username: '',
      isLoggedIn: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'isLoggedIn': isLoggedIn,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      isLoggedIn: json['isLoggedIn'] ?? false,
    );
  }
}
