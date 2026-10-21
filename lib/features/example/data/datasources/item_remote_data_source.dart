import 'package:dio/dio.dart';
import 'package:flutter_starter/core/constants/api_constants.dart';
import 'package:flutter_starter/features/example/data/models/item_dto.dart';
import 'package:injectable/injectable.dart';

abstract interface class IItemRemoteDataSource {
  Future<List<ItemDto>> getItems({int page = 1, int limit = 20});
  Future<ItemDto> getItem(int id);
  Future<ItemDto> createItem({required String title, required String body});
}

@LazySingleton(as: IItemRemoteDataSource)
class ItemRemoteDataSourceImpl implements IItemRemoteDataSource {
  final Dio _dio;

  ItemRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ItemDto>> getItems({int page = 1, int limit = 20}) async {
    final response = await _dio.get(
      ApiConstants.items,
      queryParameters: {'_page': page, '_limit': limit},
    );

    final data = response.data;
    if (data is List) {
      return data
          .map((item) => ItemDto.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<ItemDto> getItem(int id) async {
    final response = await _dio.get(ApiConstants.itemDetail(id));
    return ItemDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ItemDto> createItem({
    required String title,
    required String body,
  }) async {
    final response = await _dio.post(
      ApiConstants.items,
      data: {'title': title, 'body': body},
    );
    return ItemDto.fromJson(response.data as Map<String, dynamic>);
  }
}
