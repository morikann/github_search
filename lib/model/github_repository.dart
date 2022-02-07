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

  factory GithubRepository.fromJson(Map<String, dynamic> json) {
    return GithubRepository(
      name: json['name'] as String,
      ownerName: (json['owner'] as Map<String, dynamic>)['login'] as String,
      ownerAvatarUrl:
          (json['owner'] as Map<String, dynamic>)['avatar_url'] as String,
      language: (json['language'] ?? '') as String,
      starCount: json['stargazers_count'] as int,
      watcherCount: json['watchers_count'] as int,
      folkCount: json['forks_count'] as int,
      issueCount: json['open_issues_count'] as int,
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
      repositories.add(GithubRepository.fromJson(data));
    }
    return repositories;
  }
}
