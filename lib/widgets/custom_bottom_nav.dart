import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        "label": "Timeline",
        "icon": Icons.event_note_outlined,
        "activeIcon": Icons.event_note_rounded,
      },
      {
        "label": "Coverage",
        "icon": Icons.shield_outlined,
        "activeIcon": Icons.shield_rounded,
      },
      {
        "label": "Search",
        "icon": Icons.search_rounded,
        "activeIcon": Icons.search_rounded,
      },
      {
        "label": "Profile",
        "icon": Icons.account_circle_outlined,
        "activeIcon": Icons.account_circle_rounded,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = selectedIndex == index;
              final item = items[index];

              return GestureDetector(
                onTap: () => onItemTapped(index),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 70,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon with soft lavender circular highlight when selected
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.softLavender : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSelected ? (item["activeIcon"] as IconData) : (item["icon"] as IconData),
                          color: isSelected ? AppColors.primary : const Color(0xFF4A4A4A),
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Label Text
                      Text(
                        item["label"] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppColors.primaryDark : const Color(0xFF6B6B6B),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
