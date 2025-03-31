import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteConfig {
  static String get endpoint => dotenv.get('APPWRITE_ENDPOINT');

  static String get projectId => dotenv.get('APPWRITE_PROJECT_ID');

  static String get databaseId => dotenv.get('APPWRITE_DATABASE_ID');

  // Collections
  static String get usersCollectionId => dotenv.get('USERS_COLLECTION_ID');

  static String get notesCollectionId => dotenv.get('NOTES_COLLECTION_ID');

  //Gmail In App Password
  static String get gmailInAppPassword => dotenv.get('GMAIL_IN_APP_PASSWORD');

  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}
