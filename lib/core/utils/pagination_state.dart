import 'package:flutter_starter/core/errors/failure.dart';

class PaginationState<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final bool hasMore;
  final bool isLoadingFirstPage;
  final bool isLoadingMore;
  final Failure? failure;

  const PaginationState({
    this.items = const [],
    this.page = 1,
    this.pageSize = 20,
    this.hasMore = true,
    this.isLoadingFirstPage = false,
    this.isLoadingMore = false,
    this.failure,
  });

  bool get isEmpty => items.isEmpty && !isLoadingFirstPage;
  bool get isNotEmpty => items.isNotEmpty;
  int get itemCount => items.length;

  PaginationState<T> toLoadingFirstPage() {
    return copyWith(
      isLoadingFirstPage: true,
      isLoadingMore: false,
      failure: null,
    );
  }

  PaginationState<T> toLoadingMore() {
    return copyWith(isLoadingMore: true, failure: null);
  }

  PaginationState<T> toSuccess({
    required List<T> newItems,
    bool isRefresh = false,
  }) {
    final updatedItems = isRefresh ? newItems : [...items, ...newItems];
    final hasMoreItems = newItems.length >= pageSize;

    return PaginationState<T>(
      items: updatedItems,
      page: isRefresh ? 1 : page + 1,
      pageSize: pageSize,
      hasMore: hasMoreItems,
      isLoadingFirstPage: false,
      isLoadingMore: false,
      failure: null,
    );
  }

  PaginationState<T> toFailure(Failure failure) {
    return copyWith(
      isLoadingFirstPage: false,
      isLoadingMore: false,
      failure: failure,
    );
  }

  PaginationState<T> copyWith({
    List<T>? items,
    int? page,
    int? pageSize,
    bool? hasMore,
    bool? isLoadingFirstPage,
    bool? isLoadingMore,
    Failure? failure,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isLoadingFirstPage: isLoadingFirstPage ?? this.isLoadingFirstPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      failure: failure,
    );
  }
}
