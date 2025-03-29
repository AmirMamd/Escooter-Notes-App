import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import '../services/app_write_service.dart';
import '../utils/config/config.dart';

class UserRepository {
  final AppwriteService _appwriteService;

  UserRepository(this._appwriteService);

  Future<Document> getUserData(String userId) async {
    try {
      return await _appwriteService.databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        documentId: userId,
      );
    } on AppwriteException catch (e) {
      throw e.message ?? 'Failed to get user data';
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _appwriteService.databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        documentId: userId,
        data: data,
      );
    } on AppwriteException catch (e) {
      throw e.message ?? 'Failed to update profile';
    }
  }
}