import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int? cartCount;
  final VoidCallback? onCartTap;
  final VoidCallback? onProfileTap;

  const AppBarWidget({
    Key? key,
    required this.title,
    this.cartCount,
    this.onCartTap,
    this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      actions: [
        if (onProfileTap != null)
          IconButton(
            onPressed: onProfileTap,
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        if (cartCount != null)
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: onCartTap,
              child: Stack(
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 28,
                  ),
                  if (cartCount! > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '$cartCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
