import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/theme.dart';
import '../services/book_service.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  String description = "Loading description...";
  bool isLoading = true;

  Map<String, dynamic>? bookData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final extra =
        GoRouterState.of(context).extra as Map<String, dynamic>?;

    if (bookData == null) {
      bookData = extra ?? {};
      fetchDescription();
    }
  }

  Future<void> fetchDescription() async {
    final workKey = bookData?["key"];

    if (workKey == null) {
      setState(() {
        description = "No description available";
        isLoading = false;
      });
      return;
    }

    try {
      final desc = await BookService.getBookDescription(workKey);

      if (!mounted) return;

      setState(() {
        description = desc;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        description = "Failed to load description";
        isLoading = false;
      });
    }
  }


  String formatDescription(String text, {int maxLength = 300}) {
    if (text.length <= maxLength) return text;
    return "${text.substring(0, maxLength)}...";
  }

  @override
  Widget build(BuildContext context) {
    final title = bookData?["title"] ?? "The Alchemist";
    final author = bookData?["author"] ?? "Paulo Coelho";
    final year = bookData?["year"] ?? "1988";
    final rating = bookData?["rating"] ?? "4.7";
    final image = bookData?["image"] ??
        "https://covers.openlibrary.org/b/id/8167896-L.jpg";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Details"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  image,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "$author • $year",
              style: const TextStyle(
                fontSize: 15,
                color: AppTheme.textSecondary,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.star,
                    color: AppTheme.secondaryColor, size: 20),
                const SizedBox(width: 6),
                Text(
                  rating.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              isLoading
                  ? "Loading..."
                  : formatDescription(description), // ✅ FIX HERE
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppTheme.textSecondary,
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push(
                    '/add-review',
                    extra: {
                      "bookTitle": title,
                      "image": image,
                      "rating": rating,
                      "year": year,
                    },
                  );
                },
                child: const Text(
                  "Write Review",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}