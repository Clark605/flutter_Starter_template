// Copy to lib/features/example/data/datasources/firebase_item_remote_data_source.dart when cloud_firestore is added.
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_starter/features/example/data/datasources/item_remote_data_source.dart';
import 'package:flutter_starter/features/example/data/models/item_dto.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IItemRemoteDataSource)
class FirebaseItemRemoteDataSourceImpl implements IItemRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<ItemDto>> getItems({int page = 1, int limit = 20}) async {
    final snapshot = await _firestore
        .collection('items')
        .orderBy('id')
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => ItemDto.fromJson(doc.data())).toList();
  }

  @override
  Future<ItemDto> getItem(int id) async {
    final doc = await _firestore.collection('items').doc(id.toString()).get();
    if (!doc.exists) throw Exception('Item not found');
    return ItemDto.fromJson(doc.data()!);
  }

  @override
  Future<ItemDto> createItem({required String title, required String body}) async {
    final newDoc = _firestore.collection('items').doc();
    final item = ItemDto(id: newDoc.id.hashCode, title: title, body: body);
    await newDoc.set(item.toJson());
    return item;
  }
}
*/
