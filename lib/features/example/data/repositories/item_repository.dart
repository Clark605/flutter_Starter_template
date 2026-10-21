import 'package:flutter_starter/core/errors/result.dart';
import 'package:flutter_starter/features/example/data/models/item_model.dart';

abstract interface class ItemRepository {
  Future<Result<List<ItemModel>>> getItems({int page = 1, int limit = 20});
  Future<Result<ItemModel>> getItem(int id);
  Future<Result<ItemModel>> createItem({
    required String title,
    required String body,
  });
}
