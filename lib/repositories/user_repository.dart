import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import '../services/app_write_service.dart';
import '../utils/config/config.dart';

class UserRepository {
  final AppwriteService _appwriteService;

  UserRepository(this._appwriteService);

  Future<Document> createUser({
    required String userId,
    required String email,
    String? name,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final data = {
        'email': email,
        'name': name,
        ...?additionalData, // Spread additional data if provided
      };

      return await _appwriteService.databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollectionId,
        documentId: userId,
        // Using the same ID as the auth system
        data: data,
        permissions: [
          Permission.read(Role.user(userId)), // User can read their own doc
          Permission.update(Role.user(userId)), // User can update their own doc
        ],
      );
    } on AppwriteException catch (e) {
      throw e.message ?? 'Failed to create user profile';
    }
  }

  Future<Document> getUserData(String userId) async {
    try {
      return await _appwriteService.databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollectionId,
        documentId: userId,
      );
    } on AppwriteException catch (e) {
      throw e.message ?? 'Failed to get user data';
    }
  }

  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      await _appwriteService.databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollectionId,
        documentId: userId,
        data: data,
      );
    } on AppwriteException catch (e) {
      throw e.message ?? 'Failed to update profile';
    }
  }
}
