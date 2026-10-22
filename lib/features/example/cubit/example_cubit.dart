import 'package:flutter_starter/core/cubit/base_cubit.dart';
import 'package:flutter_starter/core/errors/failure.dart';
import 'package:flutter_starter/core/errors/result.dart';
import 'package:flutter_starter/core/utils/load_status.dart';
import 'package:flutter_starter/features/example/cubit/example_state.dart';
import 'package:flutter_starter/features/example/data/models/item_model.dart';
import 'package:flutter_starter/features/example/data/repositories/item_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExampleCubit extends BaseCubit<ExampleState> {
  final ItemRepository _repository;
  static const int _pageSize = 10;

  ExampleCubit(this._repository) : super(const ExampleState());

  Future<void> loadItems() async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final result = await guard<List<ItemModel>>(
      () => _repository.getItems(page: 1, limit: _pageSize),
      key: 'load_items_initial',
    );

    result.fold(
      (items) {
        emit(
          state.copyWith(
            status: LoadStatus.success,
            items: items,
            hasMore: items.length >= _pageSize,
            page: 1,
            failure: null,
          ),
        );
      },
      (failure) {
        if (failure is! CancelledFailure) {
          emit(state.copyWith(status: LoadStatus.failure, failure: failure));
        }
      },
    );
  }

  Future<void> refresh() async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final result = await guard<List<ItemModel>>(
      () => _repository.getItems(page: 1, limit: _pageSize),
      key: 'refresh_items',
    );

    result.fold(
      (items) {
        emit(
          state.copyWith(
            status: LoadStatus.success,
            items: items,
            hasMore: items.length >= _pageSize,
            page: 1,
            failure: null,
          ),
        );
      },
      (failure) {
        if (failure is CancelledFailure) return;
        if (state.items.isEmpty) {
          emit(state.copyWith(status: LoadStatus.failure, failure: failure));
        } else {
          // Keep existing items on a failed pull-to-refresh
          emit(state.copyWith(status: LoadStatus.success, failure: null));
        }
      },
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));
    final nextPage = state.page + 1;

    final result = await guard<List<ItemModel>>(
      () => _repository.getItems(page: nextPage, limit: _pageSize),
      key: 'load_more_items',
    );

    result.fold(
      (newItems) {
        emit(
          state.copyWith(
            items: [...state.items, ...newItems],
            hasMore: newItems.length >= _pageSize,
            isLoadingMore: false,
            page: nextPage,
          ),
        );
      },
      (failure) {
        emit(state.copyWith(isLoadingMore: false));
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
      emit(state.copyWith(items: [newItem, ...state.items]));
    }, (_) {});

    return result;
  }
}
