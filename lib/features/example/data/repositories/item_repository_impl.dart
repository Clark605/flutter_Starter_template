import 'package:flutter_starter/features/example/data/datasources/item_remote_data_source.dart';
import 'package:flutter_starter/features/example/data/models/item_model.dart';
import 'package:flutter_starter/features/example/data/repositories/item_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ItemRepository)
class ItemRepositoryImpl implements ItemRepository {
  final ItemRemoteDataSource _remoteDataSource;

  ItemRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ItemModel>> getItems({int page = 1, int limit = 20}) =>
      _remoteDataSource.getItems(page: page, limit: limit);

  @override
  Future<ItemModel> getItem(int id) => _remoteDataSource.getItem(id);

  @override
  Future<ItemModel> createItem({required String title, required String body}) =>
      _remoteDataSource.createItem(title: title, body: body);
}
