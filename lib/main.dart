import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes/app_routes.dart';
import 'utils/theme.dart';
import 'providers/review_provider.dart';

void main() {
  runApp(const NovellaApp());
}

class NovellaApp extends StatelessWidget {
  const NovellaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReviewProvider(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Novella App',
        theme: AppTheme.lightTheme,
        routerConfig: AppRoutes.router,
      ),
    );
  }
}