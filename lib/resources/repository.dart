import 'dart:async';

import 'package:crypto_wallet/models/User.dart';
import 'package:crypto_wallet/resources/user_api_provider.dart';

class Repository {
  final userApiProvider = UserApiProvider();

  Future<User> fetchUsers() => userApiProvider.fetchUsers();
}