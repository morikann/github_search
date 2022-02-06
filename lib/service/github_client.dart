import 'package:github_search/model/github_repository.dart';
import 'package:http/http.dart' as http;

class GithubClient {
  GithubClient({this.baseUrl = 'https://api.github.com/search/repositories'});

  final String baseUrl;

  Future<List<GithubRepository>?> getData(String query, {int page = 1}) async {
    final url = '$baseUrl?page=$page&q=$query';
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) {
        throw Exception('データを取得できませんでした。');
      }
      final json = res.body;
      return GithubRepository.getRepositories(json);
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }
}
