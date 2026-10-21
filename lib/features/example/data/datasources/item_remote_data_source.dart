import 'package:dio/dio.dart';
import 'package:flutter_starter/core/constants/api_constants.dart';
import 'package:flutter_starter/features/example/data/models/item_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class ItemRemoteDataSource {
  Future<List<ItemModel>> getItems({int page = 1, int limit = 20});
  Future<ItemModel> getItem(int id);
  Future<ItemModel> createItem({required String title, required String body});
}

@LazySingleton(as: ItemRemoteDataSource)
class ItemRemoteDataSourceImpl implements ItemRemoteDataSource {
  final Dio _dio;

  ItemRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ItemModel>> getItems({int page = 1, int limit = 20}) async {
    final response = await _dio.get(
      ApiConstants.items,
      queryParameters: {
        '_page': page,
        '_limit': limit,
        'skip': (page - 1) * limit,
        'limit': limit,
      },
    );

    final data = response.data;
    if (data is List) {
      return data
          .map((item) => ItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (data is Map<String, dynamic> && data['posts'] is List) {
      return (data['posts'] as List)
          .map((item) => ItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<ItemModel> getItem(int id) async {
    final response = await _dio.get(ApiConstants.itemDetail(id));
    return ItemModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ItemModel> createItem({
    required String title,
    required String body,
  }) async {
    final response = await _dio.post(
      ApiConstants.items,
      data: {'title': title, 'body': body},
    );
    return ItemModel.fromJson(response.data as Map<String, dynamic>);
  }
}
