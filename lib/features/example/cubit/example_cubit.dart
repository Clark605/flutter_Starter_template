import 'package:flutter_starter/core/cubit/base_cubit.dart';
import 'package:flutter_starter/core/errors/failure.dart';
import 'package:flutter_starter/core/errors/result.dart';
import 'package:flutter_starter/core/utils/action_token.dart';
import 'package:flutter_starter/features/example/cubit/example_state.dart';
import 'package:flutter_starter/features/example/data/models/item_model.dart';
import 'package:flutter_starter/features/example/data/repositories/item_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExampleCubit extends BaseCubit<ExampleState> {
  final ItemRepository _repository;
  static const int _pageSize = 10;

  ExampleCubit(this._repository) : super(const ExampleState.initial());

  Future<void> loadItems({ActionToken? token}) async {
    emit(const ExampleState.loading());

    final result = await guard<List<ItemModel>>(
      () async {
        final repoResult = await _repository.getItems(
          page: 1,
          limit: _pageSize,
        );
        return repoResult.fold((items) => items, (failure) => throw failure);
      },
      key: 'load_items_initial',
      token: token,
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
        if (failure is! CancelledFailure) {
          emit(ExampleState.error(failure));
        }
      },
    );
  }

  Future<void> refresh({ActionToken? token}) async {
    final result = await guard<List<ItemModel>>(
      () async {
        final repoResult = await _repository.getItems(
          page: 1,
          limit: _pageSize,
        );
        return repoResult.fold((items) => items, (failure) => throw failure);
      },
      key: 'refresh_items',
      token: token,
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
        if (failure is CancelledFailure) return;
        // If already showing loaded items, keep them on pull-to-refresh failure
        state.maybeWhen(
          loaded: (items, hasMore, isLoadingMore, page) {},
          orElse: () => emit(ExampleState.error(failure)),
        );
      },
    );
  }

  Future<void> loadMore({ActionToken? token}) async {
    final currentState = state;
    if (currentState is! ExampleStateLoaded ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));
    final nextPage = currentState.page + 1;

    final result = await guard<List<ItemModel>>(
      () async {
        final repoResult = await _repository.getItems(
          page: nextPage,
          limit: _pageSize,
        );
        return repoResult.fold((items) => items, (failure) => throw failure);
      },
      key: 'load_more_items',
      token: token,
    );

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

  Future<Result<ItemModel>> createItem({
    required String title,
    required String body,
    ActionToken? token,
  }) async {
    return guard<ItemModel>(
      () async {
        final repoResult = await _repository.createItem(
          title: title,
          body: body,
        );
        return repoResult.fold((item) => item, (failure) => throw failure);
      },
      key: 'create_item',
      token: token,
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
