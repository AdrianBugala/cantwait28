import 'package:cantwait28/models/item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemRepository {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  Stream<List<ItemModel>> getItemStream() {
    if (userID == null) {
      throw Exception('User is not logged in');
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .orderBy('release_date')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map(
        (doc) {
          return ItemModel(
            id: doc.id,
            title: doc['title'],
            imageURL: doc['image_url'],
            releaseDate: (doc['release_date'] as Timestamp).toDate(),
          );
        },
      ).toList();
    });
  }

  Future<void> delete({required String id}) async {
    if (userID == null) {
      throw Exception('User is not logged in');
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .doc(id)
        .delete();
  }

  Future<ItemModel> get({required String id}) async {
    if (userID == null) {
      throw Exception('User is not logged in');
    }
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .doc(id)
        .get();
    return ItemModel(
      id: doc.id,
      title: doc['title'],
      imageURL: doc['image_url'],
      releaseDate: (doc['release_date'] as Timestamp).toDate(),
    );
  }

  Future<void> add(String title, String imageURL, DateTime releaseDate) async {
    if (userID == null) {
      throw Exception('User is not logged in');
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('items')
        .add(
      {
        'title': title,
        'image_url': imageURL,
        'release_date': releaseDate,
      },
    );
  }
}
