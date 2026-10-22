import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/l10n/l10n_extension.dart';
import 'package:flutter_starter/core/routes/app_navigator.dart';
import 'package:flutter_starter/core/routes/route_names.dart';
import 'package:flutter_starter/core/theme/app_spacing.dart';
import 'package:flutter_starter/core/utils/load_status.dart';
import 'package:flutter_starter/core/widgets/app_button.dart';
import 'package:flutter_starter/core/widgets/app_empty_state.dart';
import 'package:flutter_starter/core/widgets/app_error_state.dart';
import 'package:flutter_starter/core/widgets/app_snackbar.dart';
import 'package:flutter_starter/core/widgets/app_text_field.dart';
import 'package:flutter_starter/core/widgets/infinite_scroll_list.dart';
import 'package:flutter_starter/features/example/cubit/example_cubit.dart';
import 'package:flutter_starter/features/example/cubit/example_state.dart';
import 'package:flutter_starter/features/example/data/models/item_model.dart';
import 'package:flutter_starter/features/example/ui/example_detail_args.dart';
import 'package:flutter_starter/features/example/ui/widgets/item_card.dart';
import 'package:flutter_starter/l10n/generated/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  void _showCreateBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final cubit = context.read<ExampleCubit>();
    final l10n = context.l10n;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom + AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.exampleCreateTitle,
              style: Theme.of(
                sheetContext,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            AppSpacing.gapHLg,
            AppTextField(
              controller: titleController,
              label: l10n.exampleItemTitleLabel,
              autofocus: true,
            ),
            AppSpacing.gapHMd,
            AppTextField(
              controller: bodyController,
              label: l10n.exampleItemBodyLabel,
              maxLines: 3,
            ),
            AppSpacing.gapHXl,
            AppButton(
              label: l10n.save,
              onPressed: () async {
                final title = titleController.text.trim();
                final body = bodyController.text.trim();
                if (title.isEmpty) return;

                Navigator.of(sheetContext).pop();
                final result = await cubit.createItem(title: title, body: body);
                if (context.mounted) {
                  result.fold(
                    (_) => context.showSuccessSnackBar(l10n.exampleItemCreated),
                    (failure) => context.showErrorSnackBar(
                      failure.localizedMessage(context),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: AppSpacing.edgeInsetsPage,
        itemCount: 6,
        separatorBuilder: (_, _) => AppSpacing.gapHMd,
        itemBuilder: (_, index) => ItemCard(
          item: ItemModel(
            id: index + 1,
            title: 'Loading item title placeholder',
            body:
                'Loading item description text that demonstrates shimmering bones...',
          ),
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    ExampleState state,
    ExampleCubit cubit,
    AppLocalizations l10n,
  ) {
    return InfiniteScrollList<ItemModel>(
      items: state.items,
      hasMore: state.hasMore,
      isLoadingMore: state.isLoadingMore,
      onRefresh: cubit.refresh,
      onLoadMore: cubit.loadMore,
      emptyWidget: AppEmptyState(
        title: l10n.exampleEmptyTitle,
        description: l10n.exampleEmptyMessage,
        icon: Icons.list_alt_rounded,
        ctaText: l10n.refresh,
        onCtaPressed: cubit.loadItems,
      ),
      itemBuilder: (context, item, index) => ItemCard(
        item: item,
        onTap: () {
          AppNavigator.pushNamed(
            RouteNames.exampleDetail,
            arguments: ExampleDetailArgs(itemId: item.id),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exampleTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => AppNavigator.pushNamed(RouteNames.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateBottomSheet(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ExampleCubit, ExampleState>(
        builder: (context, state) {
          final cubit = context.read<ExampleCubit>();

          return switch (state.status) {
            LoadStatus.initial || LoadStatus.loading =>
              state.items.isNotEmpty
                  ? _buildList(context, state, cubit, l10n)
                  : _buildSkeleton(),
            LoadStatus.failure =>
              state.items.isNotEmpty
                  ? _buildList(context, state, cubit, l10n)
                  : AppErrorState(
                      failure: state.failure,
                      onRetry: cubit.loadItems,
                    ),
            LoadStatus.success => _buildList(context, state, cubit, l10n),
          };
        },
      ),
    );
  }
}
