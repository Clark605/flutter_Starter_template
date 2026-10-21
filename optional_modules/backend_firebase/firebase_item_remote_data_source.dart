// Copy to lib/features/example/data/datasources/firebase_item_remote_data_source.dart when cloud_firestore is added.
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_starter/features/example/data/datasources/item_remote_data_source.dart';
import 'package:flutter_starter/features/example/data/models/item_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ItemRemoteDataSource)
class FirebaseItemRemoteDataSourceImpl implements ItemRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<ItemModel>> getItems({int page = 1, int limit = 20}) async {
    final snapshot = await _firestore
        .collection('items')
        .orderBy('id')
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => ItemModel.fromJson(doc.data())).toList();
  }

  @override
  Future<ItemModel> getItem(int id) async {
    final doc = await _firestore.collection('items').doc(id.toString()).get();
    if (!doc.exists) throw Exception('Item not found');
    return ItemModel.fromJson(doc.data()!);
  }

  @override
  Future<ItemModel> createItem({required String title, required String body}) async {
    final newDoc = _firestore.collection('items').doc();
    final item = ItemModel(id: newDoc.id.hashCode, title: title, body: body);
    await newDoc.set(item.toJson());
    return item;
  }
}
*/
