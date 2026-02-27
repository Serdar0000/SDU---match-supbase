import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sdu_match/core/theme/app_theme.dart';
import 'package:sdu_match/l10n/generated/app_localizations.dart';

class MainWrapperPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapperPage({
    super.key,
    required this.navigationShell,
  });

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context)!;
    final theme = Theme.of(context);
    final surfaceColor = theme.brightness == Brightness.dark
        ? AppColors.darkSurface
        : AppColors.surface;

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.person_outline, Icons.person, l.profile),
              _buildNavItem(context, 1, Icons.style_outlined, Icons.style, l.swipe),
              _buildNavItem(context, 2, Icons.chat_bubble_outline, Icons.chat_bubble, l.matches),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    IconData selectedIcon,
    String label,
  ) {
    final isSelected = navigationShell.currentIndex == index;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _goBranch(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) {
                // Простая slide анимация слева направо
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.3, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Icon(
                isSelected ? selectedIcon : icon,
                key: ValueKey(isSelected),
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.textTheme.bodyMedium?.color ??
                        AppColors.textSecondary,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              child: isSelected
                  ? Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
