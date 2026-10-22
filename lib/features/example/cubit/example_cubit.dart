import 'package:flutter_starter/core/cubit/base_cubit.dart';
import 'package:flutter_starter/core/errors/failure.dart';
import 'package:flutter_starter/core/errors/result.dart';
import 'package:flutter_starter/features/example/cubit/example_state.dart';
import 'package:flutter_starter/features/example/data/models/item_model.dart';
import 'package:flutter_starter/features/example/data/repositories/item_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExampleCubit extends BaseCubit<ExampleState> {
  final ItemRepository _repository;
  static const int _pageSize = 10;

  ExampleCubit(this._repository) : super(const ExampleState.initial());

  Future<void> loadItems() async {
    emit(const ExampleState.loading());

    final result = await guard<List<ItemModel>>(
      () => _repository.getItems(page: 1, limit: _pageSize),
      key: 'load_items_initial',
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

  Future<void> refresh() async {
    final result = await guard<List<ItemModel>>(
      () => _repository.getItems(page: 1, limit: _pageSize),
      key: 'refresh_items',
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

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! ExampleStateLoaded ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));
    final nextPage = currentState.page + 1;

    final result = await guard<List<ItemModel>>(
      () => _repository.getItems(page: nextPage, limit: _pageSize),
      key: 'load_more_items',
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
  }) async {
    final result = await guard<ItemModel>(
      () => _repository.createItem(title: title, body: body),
      key: 'create_item',
    );

    result.fold((newItem) {
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
    }, (_) {});

    return result;
  }
}
