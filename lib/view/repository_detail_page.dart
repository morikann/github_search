import 'package:flutter/material.dart';

class RepositoryDetailPage extends StatelessWidget {
  const RepositoryDetailPage(
      {this.name,
      this.ownerName,
      this.ownerAvatarUrl,
      this.language,
      this.starCount,
      this.watcherCount,
      this.folkCount,
      this.issueCount,
      Key? key})
      : super(key: key);

  final String? name;
  final String? ownerName;
  final String? ownerAvatarUrl;
  final String? language;
  final int? starCount;
  final int? watcherCount;
  final int? folkCount;
  final int? issueCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(ownerAvatarUrl!),
              radius: 16,
            ),
            const SizedBox(width: 6),
            Text(ownerName ?? 'リポジトリ'),
          ],
        ),
      ),
    );
  }
}
