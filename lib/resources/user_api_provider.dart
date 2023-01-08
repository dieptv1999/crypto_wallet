import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:crypto_wallet/models/User.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class UserApiProvider {
  Client client = Client();
  User? _user;

  Future<User> fetchUsers() async {
    print("entered");
    final response = await client
        .get(Uri.parse("http://api.themoviedb.org/3/movie/popular?api_key="));
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return User.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<bool> isUserSignedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();
    return result.isSignedIn;
  }

  Future<AuthUser> getCurrentUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user;
  }

  Future<User?> getUser() async {
    if (_user != null) return _user;
    return null;
  }
}