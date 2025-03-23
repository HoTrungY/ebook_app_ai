class Book {
  final String id;
  final String title;
  final String author;
  final String cover;
  final double? rating;
  final double? progress;
  final String? publisher;
  final String? year;
  final int? pages;
  final int? readers;
  final String? description;
  final double? price;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.cover,
    this.rating,
    this.progress,
    this.publisher,
    this.year,
    this.pages,
    this.readers,
    this.description,
    this.price,
  });

  // Constructor to create a Book from a Map (JSON)
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      cover: json['cover'] ?? '',
      rating: json['rating']?.toDouble(),
      progress: json['progress']?.toDouble(),
      publisher: json['publisher'],
      year: json['year'],
      pages: json['pages'],
      readers: json['readers'],
      description: json['description'],
      price: json['price']?.toDouble(),
    );
  }

  // Convert Book to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'cover': cover,
      'rating': rating,
      'progress': progress,
      'publisher': publisher,
      'year': year,
      'pages': pages,
      'readers': readers,
      'description': description,
      'price': price,
    };
  }

  // Copy with method for immutability support
  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? cover,
    double? rating,
    double? progress,
    String? publisher,
    String? year,
    int? pages,
    int? readers,
    String? description,
    double? price,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      cover: cover ?? this.cover,
      rating: rating ?? this.rating,
      progress: progress ?? this.progress,
      publisher: publisher ?? this.publisher,
      year: year ?? this.year,
      pages: pages ?? this.pages,
      readers: readers ?? this.readers,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }
}