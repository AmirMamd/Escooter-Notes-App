import 'package:appwrite/models.dart' as appwrite;
import 'package:escooter_notes_app/view_models/authentication/authentication_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthenticationRepository mockAuthRepo;
  late MockUserRepository mockUserRepo;
  late AuthenticationProvider authProvider;
  late appwrite.User fakeUser;
  late appwrite.Document fakeUserData;

  setUp(() {
    mockAuthRepo = MockAuthenticationRepository();
    mockUserRepo = MockUserRepository();
    authProvider = AuthenticationProvider(mockAuthRepo, mockUserRepo);

    fakeUser = appwrite.User(
      $id: 'userId',
      $createdAt: DateTime.now().toIso8601String(),
      $updatedAt: DateTime.now().toIso8601String(),
      accessedAt: DateTime.now().toIso8601String(),
      name: 'Test User',
      registration: DateTime.now().toIso8601String(),
      status: true,
      passwordUpdate: DateTime.now().toIso8601String(),
      email: 'test@example.com',
      phone: '',
      emailVerification: true,
      phoneVerification: false,
      prefs: appwrite.Preferences(data: {}),
      labels: [],
      mfa: false,
      targets: [],
    );

    fakeUserData = appwrite.Document(
      $id: 'userId',
      $collectionId: 'mockCollection',
      $databaseId: 'mockDB',
      $createdAt: DateTime.now().toIso8601String(),
      $updatedAt: DateTime.now().toIso8601String(),
      $permissions: [],
      data: {
        'name': 'Test User',
        'email': 'test@example.com',
        'emailVerification': true,
      },
    );
  });

  test('initialize sets isAuthenticated to true if already logged in',
      () async {
    when(mockAuthRepo.isLoggedIn()).thenAnswer((_) async => true);
    when(mockAuthRepo.getCurrentUser()).thenAnswer((_) async => fakeUser);
    when(mockUserRepo.getUserData('userId'))
        .thenAnswer((_) async => fakeUserData);

    await authProvider.initialize();

    expect(authProvider.isAuthenticated, true);
    expect(authProvider.currentUser?.$id, 'userId');
  });

  test('login updates state on success', () async {
    when(mockAuthRepo.login('email', 'password')).thenAnswer((_) async {});
    when(mockAuthRepo.getCurrentUser()).thenAnswer((_) async => fakeUser);
    when(mockUserRepo.getUserData('userId'))
        .thenAnswer((_) async => fakeUserData);

    await authProvider.login('email', 'password');

    expect(authProvider.isAuthenticated, true);
    expect(authProvider.currentUser?.data['name'], 'Test User');
    expect(authProvider.errorMessage, isNull);
  });

  test('login sets error on failure', () async {
    when(mockAuthRepo.login('email', 'password'))
        .thenThrow(Exception('Login failed'));

    await authProvider.login('email', 'password');

    expect(authProvider.isAuthenticated, false);
    expect(authProvider.errorMessage, contains('Login failed'));
  });
}
