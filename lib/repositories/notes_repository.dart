import 'package:escooter_notes_app/services/app_write_service.dart';

import '../models/notes_model.dart';
import '../utils/config/config.dart';

class NotesRepository {
  final AppwriteService _appwriteService;

  NotesRepository(this._appwriteService);

  /// Fetch notes from Appwrite Database
  Future<List<Note>> getNotesFromDatabase() async {
    try {
      final documents = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.notesCollectionId,
      );

      return documents.documents.map((doc) => Note.fromJson(doc.data)).toList();
    } catch (e) {
      print('Error fetching notes from DB: $e');
      return [];
    }
  }

  /// Create a new note
  Future<void> createNote(Note note) async {
    try {
      await _appwriteService.databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.notesCollectionId,
        documentId: note.id.isEmpty ? 'unique()' : note.id,
        data: note.toJson(),
      );
    } catch (e) {
      print('Error creating note: $e');
    }
  }

  /// Update an existing note
  Future<void> updateNote(Note note) async {
    try {
      await _appwriteService.databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.notesCollectionId,
        documentId: note.id,
        data: note.toJson(),
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
}
