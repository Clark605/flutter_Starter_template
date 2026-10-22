import 'package:flutter_starter/features/example/data/models/item_model.dart';

abstract interface class ItemRepository {
  Future<List<ItemModel>> getItems({int page = 1, int limit = 20});
  Future<ItemModel> getItem(int id);
  Future<ItemModel> createItem({required String title, required String body});
}
