import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/book_details_screen.dart';
import '../screens/add_review_screen.dart';
import '../screens/my_reviews_screen.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: '/book-details',
        builder: (context, state) => const BookDetailsScreen(),
      ),

      GoRoute(
        path: '/add-review',
        builder: (context, state) => const AddReviewScreen(),
      ),

      GoRoute(
        path: '/my-reviews',
        builder: (context, state) => const MyReviewsScreen(),
      ),
    ],

    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text("Route not found"),
      ),
    ),
  );
}