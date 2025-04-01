import 'package:escooter_notes_app/models/notes_model.dart';
import 'package:escooter_notes_app/view_models/notes/notes_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  group('NotesProvider Tests', () {
    late NotesProvider provider;
    late MockNotesRepository mockRepo;
    late MockConnectivityChecker mockConnectivity;
    late MockSecureStorageInterface mockStorage;
    TestWidgetsFlutterBinding.ensureInitialized();

    setUp(() {
      mockRepo = MockNotesRepository();
      mockConnectivity = MockConnectivityChecker();
      mockStorage = MockSecureStorageInterface();

      when(mockConnectivity.hasInternet()).thenAnswer((_) async => true);
      when(mockStorage.readSecureData(any)).thenAnswer((_) async => '[]');
      when(mockStorage.writeSecureData(any, any)).thenAnswer((_) async {});

      provider = NotesProvider(mockRepo, mockConnectivity, mockStorage);
    });

    test('loadNotes should load from repo', () async {
      final fakeNotes = [
        Note.createNew(
            title: 'Note A', body: 'Body A', userId: '123', id: 'a1'),
        Note.createNew(
            title: 'Note B', body: 'Body B', userId: '123', id: 'b2'),
      ];

      when(mockRepo.getNotesFromDatabase()).thenAnswer((_) async => fakeNotes);

      await provider.loadNotes();

      expect(provider.notes.length, 2);
      expect(provider.notes.first.title, 'Note A');
    });

    test('addNote should insert at bottom', () async {
      final newNote = Note.createNew(
          title: 'Top Note', body: '💥', userId: 'id', id: 'new');

      when(mockConnectivity.hasInternet())
          .thenAnswer((_) async => false); // no internet to skip API call

      await provider.addNote(newNote);

      expect(provider.notes.first.title, 'Top Note');
    });

    test('removeNote should remove by ID', () async {
      final note =
          Note.createNew(title: 'To Remove', body: '', userId: '1', id: '123');

      when(mockConnectivity.hasInternet()).thenAnswer((_) async => false);

      await provider.addNote(note);
      provider.removeNote('123');

      expect(provider.notes.any((n) => n.id == '123'), false);
    });
  });
}
