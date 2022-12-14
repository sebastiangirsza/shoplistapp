import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@injectable
class RecipesRemoteDataSource {
  Stream<QuerySnapshot<Map<String, dynamic>>> getRecipesStream() {
    final userID = FirebaseAuth.instance.currentUser?.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('recipes')
        .orderBy('recipes_name', descending: false)
        .snapshots();
  }

  Future<void> add(
    String recipesName,
    String recipesProductName,
    String recipesMakeing,
    String imageName,
    String downloadURL,
  ) async {
    final userID = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('recipes')
        .add({
      'recipes_name': recipesName,
      'recipes_product_name': recipesProductName,
      'recipes_makeing': recipesMakeing,
      'image_name': imageName,
      'download_url': downloadURL,
    });
  }

  Future<void> delete({required String id}) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('recipes')
        .doc(id)
        .delete();
  }
}
