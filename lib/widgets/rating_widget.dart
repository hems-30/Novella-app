import 'package:flutter/material.dart';
import '../utils/theme.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final Function(double)? onRatingChanged;
  final bool isEditable;

  const RatingWidget({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: isEditable
              ? () {
                  if (onRatingChanged != null) {
                    onRatingChanged!(index + 1.0);
                  }
                }
              : null,
          child: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: AppTheme.secondaryColor,
            size: 28,
          ),
        );
      }),
    );
  }
}