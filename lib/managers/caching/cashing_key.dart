import 'dart:core';
import '../../utils/helpers/helpers.dart';
class CachingKey extends Enum<String> {
  const CachingKey(super.val);

  static const CachingKey ACCESS_TOKEN = CachingKey('ACCESS_TOKEN');
  static const CachingKey IS_ADMIN = CachingKey('IS_ADMIN');
  static const CachingKey REFRESH_TOKEN = CachingKey('REFRESH_TOKEN');
  static const CachingKey USER_ID = CachingKey('USER_ID');
  static const CachingKey USER_NAME = CachingKey('USER_NAME');
  static const CachingKey LAST_ROUTE = CachingKey('LAST_ROUTE');
  static const CachingKey ONBOARDING_COMPLETED =
      CachingKey('ONBOARDING_COMPLETED');
  static const CachingKey LAST_NAME = CachingKey('LAST_NAME');
  static const CachingKey PROFILE_PICTURE = CachingKey('PROFILE_PICTURE');
  static const CachingKey FIRST_NAME = CachingKey('FIRST_NAME');
  static const CachingKey EMAIL = CachingKey('EMAIL');
  static const CachingKey PHONE_NUMBER = CachingKey('PHONE_NUMBER');
  static const CachingKey ADDRESS = CachingKey('ADDRESS');
  static const CachingKey GENDER = CachingKey('GENDER');
  static const CachingKey ROLE = CachingKey('ROLE');
  static const CachingKey PASSWORD = CachingKey('PASSWORD');
  static const CachingKey REMEMBER_ME = CachingKey('REMEMBER_ME');
}
