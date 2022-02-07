import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:github_search/model/github_repository.dart';
import 'package:http/http.dart' as http;

class GithubClient {
  GithubClient();

  static const String baseUrl = 'https://api.github.com/search/repositories';

  Future<List<GithubRepository>?> fetchRepositories(
    http.Client client, {
    required String query,
    int page = 1,
  }) async {
    final url = '$baseUrl?page=$page&q=$query';
    final response = await client.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('データを取得できませんでした。');
    }

    return compute(parseRepositories, response.body);
  }

  List<GithubRepository> parseRepositories(String responseBody) {
    final repositories = <GithubRepository>[];
    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    final parsed =
        (json['items'] as List<dynamic>).cast<Map<String, dynamic>>();
    for (final json in parsed) {
      repositories.add(GithubRepository.fromJson(json));
    }
    return repositories;
  }
}
