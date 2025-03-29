import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteConfig {
  static String get endpoint => dotenv.get('APPWRITE_ENDPOINT');
  static String get projectId => dotenv.get('APPWRITE_PROJECT_ID');
  static String get databaseId => dotenv.get('APPWRITE_DATABASE_ID');

  // Collections (these can stay as they're not sensitive)
  static const String usersCollection = 'users';
  static const String notesCollection = 'notes';

  // Buckets
  static const String profilePicturesBucket = 'profilePictures';

  // Call this during app initialization
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}