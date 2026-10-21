import 'package:flutter/material.dart';
import 'package:flutter_starter/core/theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final BoxBorder? border;
  final bool _isUnassigned;

  const AppAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 40.0,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.border,
  }) : _isUnassigned = false;

  const AppAvatar.unassigned({
    super.key,
    this.size = 32.0,
    this.backgroundColor,
    this.textColor,
    this.border,
  }) : name = '',
       imageUrl = null,
       textStyle = null,
       _isUnassigned = true;

  String get _initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].characters.take(1).toString().toUpperCase();
    }
    return '${parts[0].characters.take(1)}${parts[1].characters.take(1)}'
        .toUpperCase();
  }

  Color get _deterministicColor {
    final seed = name.trim().toLowerCase();
    if (seed.isEmpty) return AppColors.primarySeed;
    final hash = seed.codeUnits.fold<int>(
      0,
      (prev, elem) => (prev * 31 + elem) & 0x7FFFFFFF,
    );
    return AppColors.avatarPalette[hash % AppColors.avatarPalette.length];
  }

  @override
  Widget build(BuildContext context) {
    if (_isUnassigned) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              backgroundColor ??
              Theme.of(context).colorScheme.surfaceContainerHighest,
          border: border,
        ),
        child: Icon(
          Icons.person_outline_rounded,
          size: size * 0.55,
          color: textColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: border,
          image: DecorationImage(
            image: NetworkImage(imageUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final bg = backgroundColor ?? _deterministicColor;
    final fg = textColor ?? AppColors.white;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        border: border,
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style:
            textStyle ??
            TextStyle(
              color: fg,
              fontSize: size * 0.4,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
