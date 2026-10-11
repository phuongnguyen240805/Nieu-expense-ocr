import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vku_expense_ocr/core/theme/app_theme.dart';
import 'package:vku_expense_ocr/data/models/expense_category.dart';
import 'package:vku_expense_ocr/data/models/expense_item.dart';
import 'package:vku_expense_ocr/features/expense_list/widgets/expense_summary_card.dart';
import 'package:vku_expense_ocr/features/scan_flow/screens/scan_flow_screen.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('expense summary renders in $brightness mode', (tester) async {
      final theme = brightness == Brightness.dark
          ? AppTheme.dark()
          : AppTheme.light();
      final expense = ExpenseItem.draft(
        merchant: 'VU NGOC THONG',
        amount: 1929000,
        category: ExpenseCategory.other,
        date: DateTime(2026, 9, 10),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(body: ExpenseSummaryCard(expense: expense)),
        ),
      );

      expect(find.text('VU NGOC THONG'), findsOneWidget);
      expect(find.text('10/09/2026'), findsOneWidget);
      expect(find.byType(ExpenseSummaryCard), findsOneWidget);
    });
  }

  testWidgets(
    'scan actions remain reachable on a small screen with large text',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.light(),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.5)),
              child: child!,
            ),
            home: const ScanFlowScreen(),
          ),
        ),
      );
      await tester.ensureVisible(find.text('Chọn từ thư viện'));
      await tester.pumpAndSettle();
      expect(find.text('Chụp ảnh'), findsOneWidget);
      expect(find.text('Chọn từ thư viện'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('expense card fits a narrow row with a large amount', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 280,
              height: 100,
              child: ExpenseSummaryCard(
                expense: ExpenseItem.draft(
                  merchant: 'Cửa hàng có tên giao dịch rất dài',
                  amount: 1234567890,
                  category: ExpenseCategory.shopping,
                  date: DateTime(2026, 10, 11),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
