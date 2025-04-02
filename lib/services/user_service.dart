import 'package:appwrite/models.dart';
import 'package:escooter_notes_app/managers/caching/cashing_key.dart';
import 'package:escooter_notes_app/managers/caching/security.dart';

class UserService {
  static final SecureStorageInterface _secureStorage = SecureStorage();

  Future<void> cacheUserInfo(User user) async {
    final nameParts = user.name.trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.last : '';

    await _secureStorage.writeSecureData(
        CachingKey.FIRST_NAME.value, firstName);
    await _secureStorage.writeSecureData(CachingKey.LAST_NAME.value, lastName);
    await _secureStorage.writeSecureData(CachingKey.EMAIL.value, user.email);
    await _secureStorage.writeSecureData(
        CachingKey.PHONE_NUMBER.value, user.phone);
    await _secureStorage.writeSecureData(CachingKey.USER_ID.value, user.$id);
  }
}
