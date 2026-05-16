import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/book_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../utils/theme.dart';
import '../services/book_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  bool hasError = false;

  int currentIndex = 0;

  List<dynamic> books = [];
  TextEditingController searchController = TextEditingController();
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    fetchBooks("book");
  }

  @override
  void dispose() {
    searchController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  Future<void> fetchBooks(String query) async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final data = await BookService.searchBooks(query);

      setState(() {
        books = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void onSearchChanged(String query) {
    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () {
      fetchBooks(query.isEmpty ? "book" : query);
    });
  }

  List<dynamic> get popularBooks {
    return books.take(5).toList();
  }

  List<dynamic> get recommendedBooks {
    return books.skip(5).take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Good Evening 👋",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Search books...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Popular Books",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 170,
                child: _buildHorizontalList(popularBooks),
              ),

              const SizedBox(height: 20),

              const Text(
                "Recommended",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Expanded(child: _buildRecommendedList()),
            ],
          ),
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

          if (index == 1) {
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

  Widget _buildHorizontalList(List<dynamic> list) {
    if (isLoading) {
      return const LoadingWidget(message: "Loading books...");
    }

    if (hasError) {
      return const Center(child: Text("Failed to load books"));
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final book = list[index];

        final title = book["title"] ?? "No Title";
        final author = (book["author_name"] != null)
            ? book["author_name"][0]
            : "Unknown Author";

        final image =
            "https://covers.openlibrary.org/b/id/${book["cover_i"]}-L.jpg";

        return SizedBox(
          width: 280,
          child: BookCard(
            title: title,
            author: author,
            imageUrl: image,
            onTap: () {
              context.push(
                '/book-details',
                extra: {
                  "title": title,
                  "author": author,
                  "image": image,
                  "year": book["first_publish_year"]?.toString() ?? "N/A",
                  "rating": "4.5",
                  "key": book["key"] ?? "",
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRecommendedList() {
    if (isLoading) {
      return const LoadingWidget(message: "Loading books...");
    }

    if (hasError) {
      return ErrorWidgetCustom(
        message: "Failed to load books",
        onRetry: () => fetchBooks("flutter"),
      );
    }

    return ListView.builder(
      itemCount: recommendedBooks.length,
      itemBuilder: (context, index) {
        final book = recommendedBooks[index];

        final title = book["title"] ?? "No Title";
        final author = (book["author_name"] != null)
            ? book["author_name"][0]
            : "Unknown Author";

        final image =
            "https://covers.openlibrary.org/b/id/${book["cover_i"]}-L.jpg";

        return BookCard(
          title: title,
          author: author,
          imageUrl: image,
          onTap: () {
           
            context.push(
              '/book-details',
              extra: {
                "title": title,
                "author": author,
                "image": image,
                "year": book["first_publish_year"]?.toString() ?? "N/A",
                "rating": "4.5",
                "key": book["key"] ?? "",
              },
            );
          },
        );
      },
    );
  }
}