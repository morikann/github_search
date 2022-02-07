import 'package:github_search/model/github_repository.dart';
import 'package:github_search/service/github_client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final repositoryNotifierProvider =
    StateNotifierProvider<RepositoryNotifier, List<GithubRepository>>(
        (ref) => RepositoryNotifier());

class RepositoryNotifier extends StateNotifier<List<GithubRepository>> {
  RepositoryNotifier() : super([]);

  Future<void> init(String query, {int page = 1}) async {
    try {
      final repositories = await GithubClient().fetchRepositories(
        http.Client(),
        query: query,
        page: page,
      );
      state = repositories!;
    } on Exception {
      rethrow;
    }
  }

  // これ以上読み込むデータがない時はfalseを返す
  Future<bool> more(String query, {int page = 1}) async {
    try {
      final repositories = await GithubClient().fetchRepositories(
        http.Client(),
        query: query,
        page: page,
      );
      state = [...state, ...?repositories];
      return repositories?.length == 30;
    } on Exception {
      rethrow;
    }
  }
}
