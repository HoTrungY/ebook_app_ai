class Book {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final String category;
  final int pageCount;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.category,
    required this.pageCount,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? coverUrl,
    String? category,
    int? pageCount,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      coverUrl: coverUrl ?? this.coverUrl,
      category: category ?? this.category,
      pageCount: pageCount ?? this.pageCount,
    );
  }
}