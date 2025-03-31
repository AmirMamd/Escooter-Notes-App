import 'dart:core';

import '../../utils/helpers/helpers.dart';

class CachingKey extends Enum<String> {
  const CachingKey(super.val);

  static const CachingKey ACCESS_TOKEN = CachingKey('ACCESS_TOKEN');
  static const CachingKey LAST_ROUTE = CachingKey('LAST_ROUTE');
  static const CachingKey LAST_NAME = CachingKey('LAST_NAME');
  static const CachingKey FIRST_NAME = CachingKey('FIRST_NAME');
  static const CachingKey EMAIL = CachingKey('EMAIL');
  static const CachingKey USER_ID = CachingKey('USER_ID');
  static const CachingKey PHONE_NUMBER = CachingKey('PHONE_NUMBER');
  static const CachingKey NOTES = CachingKey('NOTES');
}
