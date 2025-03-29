import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage{
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  writeSecureData(String key, String value) async{
    await storage.write(key: key, value: value);
  }

  deleteAll() async{
    await storage.deleteAll();
  }

  Future<String> readSecureData(String key) async{
    try{
      String value = await storage.read(key: key) ?? "No Data Found";
      return value;
    }catch(e){
      return e.toString();
    }
  }

  deleteSecureData(String key) async{
    await storage.delete(key: key);
  }
}