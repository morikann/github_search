import 'package:github_search/view_model/repository_notifier.dart';
import 'package:test/test.dart';

void main() {
  const query = 'tiktok';

  group('repository_notifier', () {
    test('fetch 30 repositories', () async {
      final repositories = RepositoryNotifier();
      await repositories.init(query);

      expect(repositories.state.length, 30);
    });

    test('fetch more 30 repositories', () async {
      final repositories = RepositoryNotifier();
      await repositories.init(query);

      await repositories.more(query, page: 2);
      expect(repositories.state.length, 60);
    });
  });
}
