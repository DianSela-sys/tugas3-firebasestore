import 'package:appjumat/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'users';

  Future<void> createUser(String userId, String name, String email) async {
    try {
      final user = User(id: userId, name: name, email: email);
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .set(user.toFirestore());
      print('Data berhasil ditambahkan: $userId');
    } catch (e) {
      print('Gagal menambahkan data: $e');
    }
  }

  Stream<QuerySnapshot> getUsers() {
    return _firestore.collection(_usersCollection).snapshots();
  }

  Future<User?> getUser(String userId) async {
    try {
      final docSnapshot =
      await _firestore.collection(_usersCollection).doc(userId).get();
      if (docSnapshot.exists) {
        return User.fromFirestore(docSnapshot.data()!, docSnapshot.id);
      }
      return null;
    } catch (e) {
      print('Gagal membaca data: $e');
      return null;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).delete();
      print('Data berhasil dihapus: $userId');
    } catch (e) {
      print('Gagal menghapus data: $e');
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update(updates);
      print('Data berhasil diperbarui: $userId');
    } catch (e) {
      print('Gagal memperbarui data: $e');
    }
  }
}