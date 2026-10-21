import 'package:flutter_starter/core/errors/result.dart';
import 'package:flutter_starter/features/example/data/models/item_dto.dart';

abstract interface class IItemRepository {
  Future<Result<List<ItemDto>>> getItems({int page = 1, int limit = 20});
  Future<Result<ItemDto>> getItem(int id);
  Future<Result<ItemDto>> createItem({
    required String title,
    required String body,
  });
}
