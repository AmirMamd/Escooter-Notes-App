import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:escooter_notes_app/repositories/notes_repository.dart';
import 'package:flutter/material.dart';

import '../../data/security.dart';
import '../../managers/caching/cashing_key.dart';
import '../../models/notes_model.dart';

class NotesProvider extends ChangeNotifier {
  final NotesRepository _notesRepository;

  NotesProvider(this._notesRepository);

  List<Note> _notes = [];

  List<Note> get notes => _notes;

  bool? _isLoading = false;

  bool? get isLoading => _isLoading;

  set isLoading(bool? isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  Future<void> _saveNotesToStorage() async {
    final encodedNotes = jsonEncode(_notes.map((n) => n.toJson()).toList());
    await SecureStorage().writeSecureData(
        CachingKey.NOTES.value + CachingKey.USER_ID.value, encodedNotes);
  }

  Future<void> loadNotes() async {
    isLoading = true;

    try {
      final storedNotesJson = await SecureStorage()
          .readSecureData(CachingKey.NOTES.value + CachingKey.USER_ID.value);

      if (storedNotesJson != "No Data Found" && storedNotesJson.isNotEmpty) {
        final List<dynamic> decoded = Note.decodeNotesJson(storedNotesJson);
        _notes = decoded.map((e) => Note.fromJson(e)).toList();
      }

      if (await _hasInternet()) {
        final dbNotes = await _notesRepository.getNotesFromDatabase();
        _notes = dbNotes;
        await _saveNotesToStorage();
      }
    } catch (e) {
      debugPrint('Error loading notes: $e');
    }

    isLoading = false;
  }

  Future<void> addNote(Note note) async {
    _notes.insert(0, note);
    await _saveNotesToStorage();
    notifyListeners();

    if (await _hasInternet()) {
      await _notesRepository.createNote(note);
    }
  }

  Future<void> removeNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
    await _saveNotesToStorage();
    notifyListeners();

    if (await _hasInternet()) {
      await _notesRepository.deleteNote(id);
    }
  }

  Future<void> updateNote(Note updated) async {
    final index = _notes.indexWhere((n) => n.id == updated.id);
    if (index != -1) {
      _notes[index] = updated;
      await _saveNotesToStorage();
      notifyListeners();

      if (await _hasInternet()) {
        await _notesRepository.updateNote(updated);
      }
    }
  }

  Future<void> syncNotesWithDatabase() async {
    try {
      final hasInternet = await _hasInternet();

      final encodedNotes = jsonEncode(_notes.map((e) => e.toJson()).toList());
      await SecureStorage().writeSecureData(
          CachingKey.NOTES.value + CachingKey.USER_ID.value, encodedNotes);

      if (!hasInternet) {
        debugPrint("📴 No internet, saved notes only to secure storage.");
        return;
      }

      for (final note in _notes) {
        await _notesRepository.createNote(note);
      }

      debugPrint("✅ Notes synced with backend.");
    } catch (e) {
      debugPrint("⚠️ Failed to sync notes: $e");
    }
  }
}
