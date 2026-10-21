// Copy to lib/features/example/data/datasources/supabase_item_remote_data_source.dart when supabase_flutter is added.
/*
import 'package:flutter_starter/features/example/data/datasources/item_remote_data_source.dart';
import 'package:flutter_starter/features/example/data/models/item_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: IItemRemoteDataSource)
class SupabaseItemRemoteDataSourceImpl implements IItemRemoteDataSource {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<ItemDto>> getItems({int page = 1, int limit = 20}) async {
    final from = (page - 1) * limit;
    final to = from + limit - 1;

    final response = await _client
        .from('items')
        .select()
        .range(from, to)
        .order('id', ascending: true);

    return (response as List).map((row) => ItemDto.fromJson(row)).toList();
  }

  @override
  Future<ItemDto> getItem(int id) async {
    final response = await _client
        .from('items')
        .select()
        .eq('id', id)
        .single();

    return ItemDto.fromJson(response);
  }

  @override
  Future<ItemDto> createItem({required String title, required String body}) async {
    final response = await _client
        .from('items')
        .insert({'title': title, 'body': body})
        .select()
        .single();

    return ItemDto.fromJson(response);
  }
}
*/
