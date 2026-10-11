import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/expense_list/screens/expense_list_screen.dart';
import '../features/expense_list/screens/expense_detail_screen.dart';
import '../features/reports/screens/reports_screen.dart';
import '../features/scan_flow/screens/scan_flow_screen.dart';
import '../features/scan_flow/screens/review_screen.dart';
import '../features/settings/screens/settings_screen.dart';

/// Shell widget for bottom navigation.
class _ShellScaffold extends StatelessWidget {
  final Widget child;
  final StatefulNavigationShell navigationShell;

  const _ShellScaffold({required this.child, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/scan'),
        icon: const Icon(Icons.camera_alt),
        label: const Text('Quét hóa đơn'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Chi tiêu',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Báo cáo',
          ),
        ],
      ),
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/expenses',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _ShellScaffold(
          navigationShell: navigationShell,
          child: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/expenses',
              builder: (context, state) => const ExpenseListScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) => ExpenseDetailScreen(
                    expenseId:
                        int.tryParse(state.pathParameters['id'] ?? '') ?? -1,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/reports',
              builder: (context, state) => const ReportsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/scan',
      pageBuilder: (context, state) =>
          _softPage(context, state, const ScanFlowScreen()),
    ),
    GoRoute(
      path: '/scan/review',
      pageBuilder: (context, state) =>
          _softPage(context, state, const ReviewScreen()),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) =>
          _softPage(context, state, const SettingsScreen()),
    ),
  ],
);

CustomTransitionPage<void> _softPage(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  final reduceMotion = MediaQuery.disableAnimationsOf(context);
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 260),
    reverseTransitionDuration: reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = animation.drive(CurveTween(curve: Curves.easeOutCubic));
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: curved.drive(
            Tween(begin: const Offset(0, 0.06), end: Offset.zero),
          ),
          child: child,
        ),
      );
    },
  );
}
