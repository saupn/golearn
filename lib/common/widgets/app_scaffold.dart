import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/l10n.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.school),
            label: l10n.learn,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.card_giftcard),
            label: l10n.rewards,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/domains') ||
        location.startsWith('/domain') ||
        location.startsWith('/level') ||
        location.startsWith('/module') ||
        location.startsWith('/lesson') ||
        location.startsWith('/quiz') ||
        location.startsWith('/mission'))
      return 1;
    if (location.startsWith('/rewards') || location.startsWith('/claim'))
      return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/domains');
        break;
      case 2:
        context.go('/rewards');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}
