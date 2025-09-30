class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String profilePic;
  final String bio;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profilePic = '',
    this.bio = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      profilePic: json['profilePic'] ?? '',
      bio: json['bio'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'name': name,
      'email': email,
      'role': role,
      'profilePic': profilePic,
      'bio': bio,
    };
  }
}
