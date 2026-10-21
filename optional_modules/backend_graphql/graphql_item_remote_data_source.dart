// Copy to lib/features/example/data/datasources/graphql_item_remote_data_source.dart when graphql_flutter is added.
/*
import 'package:flutter_starter/features/example/data/datasources/item_remote_data_source.dart';
import 'package:flutter_starter/features/example/data/models/item_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ItemRemoteDataSource)
class GraphQLItemRemoteDataSourceImpl implements ItemRemoteDataSource {
  final GraphQLClient _client;

  GraphQLItemRemoteDataSourceImpl(this._client);

  static const String _getItemsQuery = r'''
    query GetItems($limit: Int, $offset: Int) {
      items(limit: $limit, offset: $offset) {
        id
        title
        body
        userId
      }
    }
  ''';

  @override
  Future<List<ItemModel>> getItems({int page = 1, int limit = 20}) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_getItemsQuery),
        variables: {
          'limit': limit,
          'offset': (page - 1) * limit,
        },
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data?['items'] as List?;
    return data?.map((item) => ItemModel.fromJson(item as Map<String, dynamic>)).toList() ?? [];
  }

  @override
  Future<ItemModel> getItem(int id) async {
    throw UnimplementedError();
  }

  @override
  Future<ItemModel> createItem({required String title, required String body}) async {
    throw UnimplementedError();
  }
}
*/
