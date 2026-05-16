import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../widgets/review_card.dart';
import '../widgets/loading_widget.dart';
import '../utils/theme.dart';
import '../providers/review_provider.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  int currentIndex = 1; 

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ReviewProvider>(context, listen: false).fetchReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text("My Reviews"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Consumer<ReviewProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const LoadingWidget(message: "Loading reviews...");
            }

            final reviews = provider.reviews;

            if (reviews.isEmpty) {
              return const Center(
                child: Text(
                  "No reviews yet",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];

                return ReviewCard(
                  bookTitle: review["bookTitle"] ?? "Unknown",
                  reviewText: review["reviewText"] ?? "",
                  
                  rating: double.tryParse(
                        review["rating"].toString(),
                      ) ??
                      0,
                  progress: int.tryParse(
                        review["progress"].toString(),
                      ) ??
                      0,

                  onEdit: () {
                    context.push(
                      '/add-review',
                      extra: review,
                    );
                  },

                  onDelete: () {
                    provider.deleteReview(review["id"]);
                  },
                );
              },
            );
          },
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          if (index == 0) {
            context.go('/home');
          } else if (index == 1) {
            context.go('/my-reviews');
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "My Reviews",
          ),
        ],
      ),
    );
  }
}