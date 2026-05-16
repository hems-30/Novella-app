import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../utils/theme.dart';
import '../widgets/rating_widget.dart';
import '../providers/review_provider.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final TextEditingController reviewController = TextEditingController();

  double rating = 0;
  int progress = 0;

  bool isEditMode = false;
  Map<String, dynamic>? reviewData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final extra = GoRouterState.of(context).extra;

    if (extra != null && extra is Map<String, dynamic>) {
      reviewData = extra;

      if (reviewData?["id"] != null) { 
      isEditMode = true;
      
      reviewController.text = reviewData?["reviewText"] ?? "";

      rating = double.tryParse(
            reviewData?["rating"].toString() ?? "0",
          ) ??
          0;
      progress = int.tryParse(
            reviewData?["progress"].toString() ?? "0",
          ) ??
          0;
      } else {
        isEditMode = false;
        reviewController.clear();
        rating = 0;
        progress = 0;
      }
    }
  }
  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  void saveReview() {
    if (reviewController.text.isEmpty || rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add rating and review")),
      );
      return;
    }

    final provider = Provider.of<ReviewProvider>(context, listen: false);

    if (isEditMode) {
      provider.updateReview(
        reviewData!["id"],
        {
          "bookTitle": reviewData!["bookTitle"],
          "reviewText": reviewController.text,
          "rating": rating,
          "progress": progress,
          "image": reviewData!["image"],
        },
      );
    } else {
      provider.addReview({
        "bookTitle": reviewData?["bookTitle"] ?? "Unknown Book",
        "reviewText": reviewController.text,
        "rating": rating,
        "progress": progress,
        "image":
            reviewData?["image"] ??
            "https://covers.openlibrary.org/b/id/8167896-L.jpg",
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditMode
              ? "Review Updated Successfully"
              : "Review Added Successfully",
        ),
      ),
    );

    context.go('/my-reviews');
  }

  @override
  Widget build(BuildContext context) {
    final bookTitle = reviewData?["bookTitle"] ?? "Unknown Book";
    final image =
        reviewData?["image"] ??
        "https://covers.openlibrary.org/b/id/8167896-L.jpg";

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? "Edit Review" : "Add Review"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Column(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      image,
                      width: 170,
                      height: 240,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: Text(
                    bookTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "Rating",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            RatingWidget(
              rating: rating,
              isEditable: true,
              onRatingChanged: (value) {
                setState(() => rating = value);
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Review",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: reviewController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Write your thoughts...",
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Reading Progress",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),

            Slider(
              value: progress.toDouble(),
              min: 0,
              max: 100,
              divisions: 10,
              label: "$progress%",
              activeColor: AppTheme.primaryColor,
              onChanged: (value) {
                setState(() => progress = value.toInt());
              },
            ),

            Text(
              "$progress% completed",
              style: const TextStyle(color: AppTheme.textSecondary),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveReview,
                child: Text(
                  isEditMode ? "Update Review" : "Add Review",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}