class ReviewModel {
  final String bookTitle;
  final String bookImage;
  final String reviewText;
  final double rating;
  final int progress;

  ReviewModel({
    required this.bookTitle,
    required this.bookImage,
    required this.reviewText,
    required this.rating,
    required this.progress,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookTitle': bookTitle,
      'bookImage': bookImage,
      'reviewText': reviewText,
      'rating': rating,
      'progress': progress,
    };
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      bookTitle: json['bookTitle'] ?? '',
      bookImage: json['bookImage'] ?? '',
      reviewText: json['reviewText'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      progress: json['progress'] ?? 0,
    );
  }
}