import 'package:appwrite/models.dart' as appwrite;
import 'package:escooter_notes_app/managers/caching/security.dart';
import 'package:escooter_notes_app/repositories/authentication_repository.dart';
import 'package:escooter_notes_app/repositories/notes_repository.dart';
import 'package:escooter_notes_app/repositories/user_repository.dart';
import 'package:escooter_notes_app/utils/connectivity/connectivity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  AuthenticationRepository,
  UserRepository,
  NotesRepository,
  ConnectivityChecker,
  SecureStorageInterface,
])
void main() {}

class MockUser extends Mock implements appwrite.User {}

class MockDocument extends Mock implements appwrite.Document {}
