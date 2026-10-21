import 'package:flutter_starter/core/cubit/base_cubit.dart';
import 'package:flutter_starter/core/errors/result.dart';
import 'package:flutter_starter/features/example/cubit/example_state.dart';
import 'package:flutter_starter/features/example/data/models/item_dto.dart';
import 'package:flutter_starter/features/example/data/repositories/i_item_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExampleCubit extends BaseCubit<ExampleState> {
  final IItemRepository _repository;
  static const int _pageSize = 10;

  ExampleCubit(this._repository) : super(const ExampleState.initial());

  Future<void> loadItems() async {
    emit(const ExampleState.loading());

    final result = await guard<List<ItemDto>>(
      () async {
        final repoResult = await _repository.getItems(
          page: 1,
          limit: _pageSize,
        );
        return repoResult.fold((items) => items, (failure) => throw failure);
      },
      key: 'load_items_initial',
      retries: 2,
    );

    result.fold(
      (items) {
        emit(
          ExampleState.loaded(
            items: items,
            hasMore: items.length >= _pageSize,
            page: 1,
          ),
        );
      },
      (failure) {
        emit(ExampleState.error(failure));
      },
    );
  }

  Future<void> refresh() async {
    final result = await guard<List<ItemDto>>(() async {
      final repoResult = await _repository.getItems(page: 1, limit: _pageSize);
      return repoResult.fold((items) => items, (failure) => throw failure);
    }, key: 'refresh_items');

    result.fold(
      (items) {
        emit(
          ExampleState.loaded(
            items: items,
            hasMore: items.length >= _pageSize,
            page: 1,
          ),
        );
      },
      (failure) {
        // If already showing loaded items, don't obliterate the screen; or update state
        state.maybeWhen(
          loaded: (items, hasMore, isLoadingMore, page) {
            // Keep loaded items on pull to refresh failure
          },
          orElse: () => emit(ExampleState.error(failure)),
        );
      },
    );
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! ExampleStateLoaded ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));
    final nextPage = currentState.page + 1;

    final result = await guard<List<ItemDto>>(() async {
      final repoResult = await _repository.getItems(
        page: nextPage,
        limit: _pageSize,
      );
      return repoResult.fold((items) => items, (failure) => throw failure);
    }, key: 'load_more_items');

    result.fold(
      (newItems) {
        emit(
          currentState.copyWith(
            items: [...currentState.items, ...newItems],
            hasMore: newItems.length >= _pageSize,
            isLoadingMore: false,
            page: nextPage,
          ),
        );
      },
      (failure) {
        emit(currentState.copyWith(isLoadingMore: false));
      },
    );
  }

  Future<Result<ItemDto>> createItem({
    required String title,
    required String body,
  }) async {
    return guard<ItemDto>(
      () async {
        final repoResult = await _repository.createItem(
          title: title,
          body: body,
        );
        return repoResult.fold((item) => item, (failure) => throw failure);
      },
      key: 'create_item',
      onSuccess: (newItem) {
        state.maybeWhen(
          loaded: (items, hasMore, isLoadingMore, page) {
            emit(
              ExampleState.loaded(
                items: [newItem, ...items],
                hasMore: hasMore,
                page: page,
              ),
            );
          },
          orElse: () {},
        );
      },
    );
  }
}
