class GithubRepository {
  GithubRepository({
    this.name,
    this.ownerAvatarUrl,
    this.language,
    this.starCount,
    this.watcherCount,
    this.folkCount,
    this.issueCount,
  });

  factory GithubRepository.from(Map<String, dynamic> data) {
    return GithubRepository(
      name: data['full_name'] as String,
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
  final String? ownerAvatarUrl;
  final String? language;
  final int? starCount;
  final int? watcherCount;
  final int? folkCount;
  final int? issueCount;
}
