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

  final String? name;
  final String? ownerAvatarUrl;
  final String? language;
  final int? starCount;
  final int? watcherCount;
  final int? folkCount;
  final int? issueCount;
}
