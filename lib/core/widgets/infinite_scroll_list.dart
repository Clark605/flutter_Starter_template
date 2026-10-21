import 'package:flutter/material.dart';
import 'package:flutter_starter/core/theme/app_spacing.dart';

class InfiniteScrollList<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Future<void> Function()? onRefresh;
  final VoidCallback? onLoadMore;
  final bool hasMore;
  final bool isLoadingMore;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final IndexedWidgetBuilder? separatorBuilder;
  final EdgeInsetsGeometry? padding;
  final double loadMoreThreshold;
  final ScrollController? controller;

  const InfiniteScrollList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.onRefresh,
    this.onLoadMore,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.emptyWidget,
    this.loadingWidget,
    this.separatorBuilder,
    this.padding,
    this.loadMoreThreshold = 200.0,
    this.controller,
  });

  @override
  State<InfiniteScrollList<T>> createState() => _InfiniteScrollListState<T>();
}

class _InfiniteScrollListState<T> extends State<InfiniteScrollList<T>> {
  late ScrollController _scrollController;
  bool _createdController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _scrollController = widget.controller!;
    } else {
      _scrollController = ScrollController();
      _createdController = true;
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    if (_createdController) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (!widget.hasMore || widget.isLoadingMore || widget.onLoadMore == null) {
      return;
    }
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= widget.loadMoreThreshold) {
      widget.onLoadMore?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty && widget.emptyWidget != null) {
      if (widget.onRefresh != null) {
        return RefreshIndicator(
          onRefresh: widget.onRefresh!,
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(child: widget.emptyWidget!),
              ),
            ),
          ),
        );
      }
      return widget.emptyWidget!;
    }

    Widget content = ListView.separated(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: widget.padding ?? AppSpacing.edgeInsetsPage,
      itemCount: widget.items.length + (widget.hasMore ? 1 : 0),
      separatorBuilder: widget.separatorBuilder ?? (_, _) => AppSpacing.gapHMd,
      itemBuilder: (context, index) {
        if (index == widget.items.length) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child:
                  widget.loadingWidget ??
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
            ),
          );
        }
        return widget.itemBuilder(context, widget.items[index], index);
      },
    );

    if (widget.onRefresh != null) {
      content = RefreshIndicator(onRefresh: widget.onRefresh!, child: content);
    }

    return content;
  }
}
