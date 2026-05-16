class BookModel {
  final String title;
  final String author;
  final String image;
  final String description;
  final String publishYear;
  final double rating;

  BookModel({
    required this.title,
    required this.author,
    required this.image,
    required this.description,
    required this.publishYear,
    required this.rating,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      title: json['title'] ?? 'Unknown Title',

      author: json['author_name'] != null
          ? json['author_name'][0]
          : 'Unknown Author',

      image: json['cover_i'] != null
          ? 'https://covers.openlibrary.org/b/id/${json['cover_i']}-L.jpg'
          : 'https://via.placeholder.com/150',

      description: json['first_sentence'] != null
          ? json['first_sentence'].toString()
          : 'No description available.',

      publishYear: json['first_publish_year'] != null
          ? json['first_publish_year'].toString()
          : 'Unknown',
          
      // temporary rating beacuse open library doesn't provide ratings
      rating: 4.5,
    );
  }
}