import 'package:appwrite/models.dart';
import 'package:escooter_notes_app/services/app_write_service.dart';

import '../models/notes_model.dart';
import '../utils/config/config.dart';

class NotesRepository {
  final AppwriteService _appwriteService;

  NotesRepository(this._appwriteService);

  Future<List<Note>> getNotesFromDatabase() async {
    try {
      final documents = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.notesCollectionId,
      );

      return documents.documents.map((doc) {
        final dataWithId = {
          ...doc.data,
          'id': doc.$id, // manually add the ID
        };
        return Note.fromJson(dataWithId);
      }).toList();
    } catch (e) {
      print('Error fetching notes from DB: $e');
      return [];
    }
  }

  /// Create a new note
  Future<Document?> createNote(Note note) async {
    try {
      return await _appwriteService.databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.notesCollectionId,
        documentId: note.id.isEmpty || note.id == 'new' ? 'unique()' : note.id,
        data: note.toJsonWithoutId(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Update an existing note
  Future<void> updateNote(Note note) async {
    try {
      await _appwriteService.databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.notesCollectionId,
        documentId: note.id,
        data: note.toJsonWithoutId(),
      );
    } catch (e) {
      print('Error updating note: $e');
    }
  }

  /// Delete a note
  Future<void> deleteNote(String id) async {
    try {
      await _appwriteService.databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.notesCollectionId,
        documentId: id,
      );
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  Future<void> deleteAll() async {
    try {
      final documents = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.notesCollectionId,
      );

      for (final doc in documents.documents) {
        await _appwriteService.databases.deleteDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.notesCollectionId,
          documentId: doc.$id,
        );
      }
    } catch (e) {
      print('Error deleting all notes: $e');
      throw Exception('Failed to delete all notes: $e');
    }
  }

  Future<Document?> getNoteById(String id) async {
    try {
      return await _appwriteService.databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.notesCollectionId,
        documentId: id,
      );
    } catch (e) {
      print("Failed to get note: $e");
      return null;
    }
  }
}
