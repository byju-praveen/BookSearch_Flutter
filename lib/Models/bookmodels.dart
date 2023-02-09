//Book Model
class Book {
  final String title;
  final String? publisher;
  final String? thumbnail;
  final String? description;
  final String? author;

  Book({
    required this.title,
    this.publisher,
    this.thumbnail,
    this.description,
    this.author,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['volumeInfo']['title'],
      author: json['volumeInfo']['authors'][0],
      publisher: json['volumeInfo']['publisher'],
      thumbnail: json['volumeInfo']['imageLinks']['thumbnail'],
      description: json['volumeInfo']['description'],
    );
  }
}
