import 'package:flutter_starter/core/errors/error_mapper.dart';
import 'package:flutter_starter/core/errors/result.dart';
import 'package:flutter_starter/features/example/data/datasources/item_remote_data_source.dart';
import 'package:flutter_starter/features/example/data/models/item_dto.dart';
import 'package:flutter_starter/features/example/data/repositories/i_item_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IItemRepository)
class ItemRepositoryImpl implements IItemRepository {
  final IItemRemoteDataSource _remoteDataSource;

  ItemRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<ItemDto>>> getItems({int page = 1, int limit = 20}) async {
    try {
      final items = await _remoteDataSource.getItems(page: page, limit: limit);
      return Result.success(items);
    } on Object catch (e, st) {
      return Result.failure(ErrorMapper.map(e, st));
    }
  }

  @override
  Future<Result<ItemDto>> getItem(int id) async {
    try {
      final item = await _remoteDataSource.getItem(id);
      return Result.success(item);
    } on Object catch (e, st) {
      return Result.failure(ErrorMapper.map(e, st));
    }
  }

  @override
  Future<Result<ItemDto>> createItem({
    required String title,
    required String body,
  }) async {
    try {
      final created = await _remoteDataSource.createItem(
        title: title,
        body: body,
      );
      return Result.success(created);
    } on Object catch (e, st) {
      return Result.failure(ErrorMapper.map(e, st));
    }
  }
}
