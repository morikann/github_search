import 'package:flutter/material.dart';
import 'package:github_search/component/app_color.dart';

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
    final textTheme = Theme.of(context).textTheme;

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
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                ownerName ?? 'リポジトリ',
                style: textTheme.headline6?.copyWith(
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      name ?? '',
                      style: textTheme.subtitle1,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.star_outline),
                        Text(
                          '$starCount Star',
                          style: textTheme.bodyText2,
                        ),
                        const SizedBox(width: 20),
                        const Icon(Icons.call_split),
                        Text(
                          '$folkCount Folk',
                          style: textTheme.bodyText2,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const SizedBox(height: 20),
                      ListItem(
                        title: 'Issue',
                        color: Colors.green,
                        icon: Icons.mode_standby,
                        trailing: (issueCount ?? '?').toString(),
                      ),
                      ListItem(
                        title: 'Watcher',
                        color: Colors.yellow.shade600,
                        icon: Icons.remove_red_eye_outlined,
                        trailing: (watcherCount ?? '?').toString(),
                      ),
                      ListItem(
                        title: 'Language',
                        color: Colors.blue,
                        icon: Icons.language,
                        trailing: language ?? 'なし',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    required this.title,
    required this.color,
    required this.icon,
    required this.trailing,
    Key? key,
  }) : super(key: key);

  final String title;
  final Color color;
  final IconData icon;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: textTheme.bodyText1?.copyWith(
                  color: AppColor.text,
                ),
              ),
            ],
          ),
          Text(
            trailing,
            style: textTheme.bodyText1?.copyWith(
              color: AppColor.text,
            ),
          ),
        ],
      ),
    );
  }
}
