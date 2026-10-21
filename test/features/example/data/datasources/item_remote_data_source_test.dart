import 'package:dio/dio.dart';
import 'package:flutter_starter/features/example/data/datasources/item_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ItemRemoteDataSourceImpl', () {
    test('fetches items from https://dummyjson.com live endpoint', () async {
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://dummyjson.com',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      final dataSource = ItemRemoteDataSourceImpl(dio);

      final items = await dataSource.getItems(page: 1, limit: 10);
      expect(items, isNotEmpty);
      expect(items.length, 10);
      expect(items.first.id, isPositive);
      expect(items.first.title, isNotEmpty);
      expect(items.first.body, isNotEmpty);
    });

    test(
      'fetches single item from https://dummyjson.com live endpoint',
      () async {
        final dio = Dio(
          BaseOptions(
            baseUrl: 'https://dummyjson.com',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );
        final dataSource = ItemRemoteDataSourceImpl(dio);

        final item = await dataSource.getItem(1);
        expect(item.id, 1);
        expect(item.title, isNotEmpty);
        expect(item.body, isNotEmpty);
      },
    );
  });
}
