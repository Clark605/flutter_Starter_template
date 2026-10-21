import 'package:flutter/material.dart';
import 'package:flutter_starter/core/theme/app_radius.dart';
import 'package:flutter_starter/core/theme/app_spacing.dart';
import 'package:flutter_starter/core/widgets/app_avatar.dart';
import 'package:flutter_starter/core/widgets/status_badge.dart';
import 'package:flutter_starter/features/example/data/models/item_model.dart';

class ItemCard extends StatelessWidget {
  final ItemModel item;
  final VoidCallback? onTap;

  const ItemCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.md,
        child: Padding(
          padding: AppSpacing.edgeInsetsAllLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppAvatar(name: 'Item #${item.id}', size: 32),
                  AppSpacing.gapWSm,
                  Expanded(
                    child: Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AppSpacing.gapWSm,
                  StatusBadge(label: '#${item.id}', color: colorScheme.primary),
                ],
              ),
              AppSpacing.gapHMd,
              Text(
                item.body,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
