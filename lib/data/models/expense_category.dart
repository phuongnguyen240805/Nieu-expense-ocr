import 'package:flutter/material.dart';

enum ExpenseCategory {
  food,
  transport,
  shopping,
  utilities,
  other;

  /// Returns the corresponding icon for this category.
  IconData get icon => switch (this) {
    ExpenseCategory.food => Icons.restaurant,
    ExpenseCategory.transport => Icons.directions_car,
    ExpenseCategory.shopping => Icons.shopping_bag,
    ExpenseCategory.utilities => Icons.bolt,
    ExpenseCategory.other => Icons.category,
  };

  /// Returns the corresponding color for this category.
  Color get color => switch (this) {
    ExpenseCategory.food => const Color(0xFFC77532),
    ExpenseCategory.transport => const Color(0xFF4B86C6),
    ExpenseCategory.shopping => const Color(0xFF9970BC),
    ExpenseCategory.utilities => const Color(0xFF279986),
    ExpenseCategory.other => const Color(0xFF7B8D8A),
  };

  /// Returns localized/friendly name (Vietnamese).
  String get displayName => switch (this) {
    ExpenseCategory.food => 'Ăn uống',
    ExpenseCategory.transport => 'Đi lại',
    ExpenseCategory.shopping => 'Mua sắm',
    ExpenseCategory.utilities => 'Hóa đơn & Tiện ích',
    ExpenseCategory.other => 'Khác',
  };
}
