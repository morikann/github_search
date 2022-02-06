import 'package:github_search/model/github_repository.dart';
import 'package:http/http.dart' as http;

class GithubClient {
  GithubClient(this.baseUrl);

  String baseUrl = 'https://api.github.com/search/repositories';

  static Future<List<GithubRepository>?> getData(String query) async {
    final url = 'https://api.github.com/search/repositories?q=$query';
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
