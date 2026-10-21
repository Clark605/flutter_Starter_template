import 'package:flutter/material.dart';
import 'package:flutter_starter/core/theme/app_icon_size.dart';
import 'package:flutter_starter/core/theme/app_radius.dart';
import 'package:flutter_starter/core/theme/app_spacing.dart';
import 'package:intl/intl.dart';

class AppDateField extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;
  final String? label;
  final String placeholder;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const AppDateField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.label,
    this.placeholder = 'Select date',
    this.firstDate,
    this.lastDate,
  });

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toString();

    final formattedDate = selectedDate != null
        ? DateFormat.yMMMd(locale).format(selectedDate!)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapHSm,
        ],
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: AppRadius.md,
          child: Container(
            height: AppSpacing.huge, // 48px min touch target
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: AppIconSize.md,
                  color: colorScheme.onSurfaceVariant,
                ),
                AppSpacing.gapWMd,
                Expanded(
                  child: Text(
                    formattedDate ?? placeholder,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: formattedDate != null
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (selectedDate != null)
                  IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: AppIconSize.sm,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => onDateSelected(null),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
