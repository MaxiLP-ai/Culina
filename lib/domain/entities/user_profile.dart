class UserProfile {
  final String id;
  final String name;
  final String email;
  final String username;
  final String memberSince;
  final String bio;
  final List<String> culinaryTags;
  final String favoriteCategory;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.memberSince,
    required this.bio,
    required this.culinaryTags,
    this.favoriteCategory = 'Pastas',
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'CU';
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? username,
    String? memberSince,
    String? bio,
    List<String>? culinaryTags,
    String? favoriteCategory,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      memberSince: memberSince ?? this.memberSince,
      bio: bio ?? this.bio,
      culinaryTags: culinaryTags ?? this.culinaryTags,
      favoriteCategory: favoriteCategory ?? this.favoriteCategory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'memberSince': memberSince,
      'bio': bio,
      'culinaryTags': culinaryTags,
      'favoriteCategory': favoriteCategory,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String? ?? '1',
      name: map['name'] as String? ?? 'Matias Tapia',
      email: map['email'] as String? ?? 'matias.tapia@culina.app',
      username: map['username'] as String? ?? 'matias',
      memberSince: map['memberSince'] as String? ?? 'Marzo 2026',
      bio: map['bio'] as String? ??
          'Chef y cocinero aficionado. Amante de la cocina casera, recetas artesanales e ingredientes frescos.',
      culinaryTags: (map['culinaryTags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['Cocina casera', 'Pastas frescas', 'Ingredientes naturales'],
      favoriteCategory: map['favoriteCategory'] as String? ?? 'Pastas',
    );
  }
}

