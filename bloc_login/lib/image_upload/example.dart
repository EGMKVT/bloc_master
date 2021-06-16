import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<uri> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
    },
  );
  final responseJson = jsonDecode(response.body);

  return uri.fromJson(responseJson);
}

class uri {
  int id;
  String username;
  String token;

  uri(
      {this.id,
        this.username,
        this.token});

  factory uri.fromJson(Map<String, dynamic> data) => uri(
    id: data['id'],
    username: data['username'],
    token: data['token'],
  );

  Map<String, dynamic> toJson() => {
    "id": this.id,
    "username": this.username,
    "token": this.token
  };
}
