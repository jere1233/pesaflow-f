// lib/shared/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: foregroundColor ?? Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}