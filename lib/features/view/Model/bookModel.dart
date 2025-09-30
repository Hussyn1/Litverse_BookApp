class BookModel {
  final String id;
  final String title;
  final String description;
  final String genre;
  final String? coverImage;
  final String? bookFile;

  double averageRating;
  int ratingCount;

  BookModel({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    this.coverImage,
    this.bookFile,
    this.averageRating = 0.0,
    this.ratingCount = 0,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    const String baseUrl = "http://192.168.100.8:3000";
    return BookModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      genre: json['genre'] ?? '',
      coverImage:
          json['coverImage'] != null ? "$baseUrl${json['coverImage']}" : null,
      bookFile: json['bookFile'] != null ? "$baseUrl${json['bookFile']}" : null,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      ratingCount: json['ratingCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "genre": genre,
      "coverImage": coverImage,
      "bookFile": bookFile,
      "averageRating": averageRating,
      "ratingCount": ratingCount,
    };
  }
}
