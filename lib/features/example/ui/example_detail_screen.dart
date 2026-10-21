import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/l10n/l10n_extension.dart';
import 'package:flutter_starter/core/theme/app_spacing.dart';
import 'package:flutter_starter/core/widgets/app_avatar.dart';
import 'package:flutter_starter/core/widgets/app_error_state.dart';
import 'package:flutter_starter/core/widgets/status_badge.dart';
import 'package:flutter_starter/features/example/bloc/example_detail_bloc.dart';
import 'package:flutter_starter/features/example/bloc/example_detail_event.dart';
import 'package:flutter_starter/features/example/bloc/example_detail_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExampleDetailScreen extends StatelessWidget {
  final int itemId;

  const ExampleDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text('${l10n.exampleTitle} #$itemId')),
      body: BlocBuilder<ExampleDetailBloc, ExampleDetailState>(
        builder: (context, state) {
          final bloc = context.read<ExampleDetailBloc>();

          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => Skeletonizer(
              enabled: true,
              child: Padding(
                padding: AppSpacing.edgeInsetsPage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 32, width: 200, color: Colors.grey),
                    AppSpacing.gapHLg,
                    Container(
                      height: 100,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            error: (failure) => AppErrorState(
              failure: failure,
              onRetry: () => bloc.add(ExampleDetailEvent.load(itemId)),
            ),
            loaded: (item) => RefreshIndicator(
              onRefresh: () async {
                bloc.add(ExampleDetailEvent.refresh(itemId));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: AppSpacing.edgeInsetsPage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppAvatar(name: 'Item #${item.id}', size: 48),
                        AppSpacing.gapWMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              AppSpacing.gapHXs,
                              StatusBadge(
                                label: 'ID: ${item.id}',
                                color: theme.colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapHXl,
                    const Divider(),
                    AppSpacing.gapHXl,
                    Text(
                      item.body,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
