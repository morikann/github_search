import 'dart:convert';

class GithubRepository {
  GithubRepository({
    this.name,
    this.ownerName,
    this.ownerAvatarUrl,
    this.language,
    this.starCount,
    this.watcherCount,
    this.folkCount,
    this.issueCount,
  });

  factory GithubRepository.from(Map<String, dynamic> data) {
    return GithubRepository(
      name: data['name'] as String,
      ownerName: (data['owner'] as Map<String, dynamic>)['login'] as String,
      ownerAvatarUrl:
          (data['owner'] as Map<String, dynamic>)['avatar_url'] as String,
      language: (data['language'] ?? '') as String,
      starCount: data['stargazers_count'] as int,
      watcherCount: data['watchers_count'] as int,
      folkCount: data['forks_count'] as int,
      issueCount: data['open_issues_count'] as int,
    );
  }

  final String? name;
  final String? ownerName;
  final String? ownerAvatarUrl;
  final String? language;
  final int? starCount;
  final int? watcherCount;
  final int? folkCount;
  final int? issueCount;

  static Future<List<GithubRepository>> getRepositories(String json) async {
    final repositories = <GithubRepository>[];
    final data = jsonDecode(json) as Map<String, dynamic>;
    final items = (data['items'] as List<dynamic>).cast<Map<String, dynamic>>();
    for (final data in items) {
      repositories.add(GithubRepository.from(data));
    }
    return repositories;
  }
}
