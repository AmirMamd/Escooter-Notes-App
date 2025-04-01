import 'dart:convert';

import 'package:escooter_notes_app/repositories/notes_repository.dart';
import 'package:flutter/material.dart';

import '../../data/security.dart';
import '../../managers/caching/cashing_key.dart';
import '../../models/notes_model.dart';
import '../../utils/connectivity/connectivity.dart';
import '../../utils/helpers/helpers.dart';

class NotesProvider extends ChangeNotifier {
  final NotesRepository _notesRepository;
  final ConnectivityChecker _connectivityChecker;
  final SecureStorageInterface _secureStorage;

  NotesProvider(
      this._notesRepository, this._connectivityChecker, this._secureStorage);

  List<Note> _notes = [];

  List<Note> get notes => _notes;

  bool? _isLoading = false;

  bool? get isLoading => _isLoading;

  set isLoading(bool? isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<bool> _hasInternet() async => await _connectivityChecker.hasInternet();

  Future<void> _saveNotesToStorage() async {
    final encodedNotes = jsonEncode(_notes.map((n) => n.toJson()).toList());
    await _secureStorage.writeSecureData(
        CachingKey.NOTES.value + CachingKey.USER_ID.value, encodedNotes);
  }

  Future<void> loadNotes() async {
    isLoading = true;

    try {
      if (await _hasInternet()) {
        final dbNotes = await _notesRepository.getNotesFromDatabase();
        _notes = dbNotes;
        await _saveNotesToStorage();
      } else {
        final storedNotesJson = await _secureStorage
            .readSecureData(CachingKey.NOTES.value + CachingKey.USER_ID.value);

        if (storedNotesJson != "No Data Found" && storedNotesJson.isNotEmpty) {
          final List<dynamic> decoded = Note.decodeNotesJson(storedNotesJson);
          _notes = decoded.map((e) {
            final data = Map<String, dynamic>.from(e);
            final dataWithId = {
              ...data,
              'id': data['id'],
            };
            return Note.fromJson(dataWithId);
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('Error loading notes: $e');
    }

    isLoading = false;
  }

  Future<Note?> getNoteById(String id) async {
    final cached = _notes.firstWhere(
      (n) => n.id == id,
      orElse: () => Note.createNew(id: '', title: '', body: '', userId: ''),
    );

    if (cached.id.isNotEmpty) return cached;

    if (await _hasInternet()) {
      try {
        final doc = await _notesRepository.getNoteById(id);
        if (doc != null) {
          return Note.fromJson(doc.data);
        }
      } catch (e) {
        debugPrint("Error fetching note from API: $e");
      }
    }

    final storedNotesJson =
        await _secureStorage.readSecureData(CachingKey.NOTES.value);
    if (storedNotesJson != "No Data Found") {
      final List<dynamic> decoded = Note.decodeNotesJson(storedNotesJson);
      final localMatch = decoded.map((e) => Note.fromJson(e)).firstWhere(
          (n) => n.id == id,
          orElse: () =>
              Note.createNew(id: '', title: '', body: '', userId: ''));

      if (localMatch.id.isNotEmpty) return localMatch;
    }

    return null;
  }

  Future<void> addNote(Note note) async {
    Note noteToSave = note;
    if (note.id != '' && note.id != 'new') {
      return updateNote(note);
    }
    if (await _hasInternet()) {
      final savedNote = await _notesRepository.createNote(note);
      if (savedNote != null) {
        noteToSave = note.copyWith(id: savedNote.$id);
      }
    } else {
      noteToSave = note.copyWith(id: Helpers.generateHexId());
    }

    _notes.insert(0, noteToSave);
    await _saveNotesToStorage();
    notifyListeners();
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
}
