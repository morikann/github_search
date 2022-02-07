import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:github_search/component/app_color.dart';
import 'package:github_search/model/github_repository.dart';
import 'package:github_search/service/github_client.dart';
import 'package:github_search/view/repository_detail_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _elevationProvider = StateProvider<double>((ref) => 0);
final _searchTextProvider = StateProvider<String>((ref) => '');
final _isSearchedProvider = StateProvider<bool>((ref) => false);
final _repositoryProvider = FutureProvider<List<GithubRepository>>((ref) async {
  final query = ref.watch(_searchTextProvider);
  if (query == '') {
    return [];
  }
  final repositories = await GithubClient().getData(query);
  return repositories ?? [];
});

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final focusNode = useFocusNode();
    final scrollController = useScrollController();
    final elevation = ref.watch(_elevationProvider.state);
    final repositories = ref.watch(_repositoryProvider);
    final isSearched = ref.watch(_isSearchedProvider.state);

    void listener() {
      final scrolled = scrollController.position.pixels;
      if (scrolled >= 56) {
        elevation.state = 3;
      } else {
        elevation.state = 0;
      }
    }

    useEffect(() {
      scrollController.addListener(listener);
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: elevation.state,
        title: Text(
          'ホーム',
          style: textTheme.headline6,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: focusNode.unfocus,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                shape: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: _buildTextField(context, ref, focusNode),
                  ),
                ),
              ),
              if (isSearched.state) ...[
                repositories.when(
                  loading: () => _buildLoadingView(textTheme),
                  error: (error, _) {
                    return _buildErrorView(textTheme);
                  },
                  data: (repositories) {
                    if (repositories.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Text(
                            '該当のリポジトリは見つかりませんでした。',
                            style: textTheme.bodyText2,
                          ),
                        ),
                      );
                    } else {
                      return _buildRepositories(repositories, textTheme);
                    }
                  },
                ),
              ] else ...[
                _buildInitView(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  SliverList _buildRepositories(
      List<GithubRepository> repositories, TextTheme textTheme) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (context) {
                      return RepositoryDetailPage(
                        name: repositories[index].name,
                        ownerName: repositories[index].ownerName,
                        ownerAvatarUrl: repositories[index].ownerAvatarUrl,
                        language: repositories[index].language,
                        starCount: repositories[index].starCount,
                        watcherCount: repositories[index].watcherCount,
                        folkCount: repositories[index].folkCount,
                        issueCount: repositories[index].issueCount,
                      );
                    },
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  repositories[index].name!,
                  style: textTheme.bodyText1,
                ),
              ),
            ),
          );
        },
        childCount: repositories.length,
      ),
    );
  }

  SliverFillRemaining _buildErrorView(TextTheme textTheme) {
    return SliverFillRemaining(
      child: Center(
        child: Text(
          'データを取得できませんでした。',
          style: textTheme.bodyText2,
        ),
      ),
    );
  }

  SliverFillRemaining _buildLoadingView(TextTheme textTheme) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/github_icon.png',
              height: 100,
            ),
            Text('loading...', style: textTheme.bodyText2),
          ],
        ),
      ),
    );
  }

  SliverFillRemaining _buildInitView() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/github_icon.png',
              height: 100,
            ),
            const Text('リポジトリを検索してみよう'),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context, WidgetRef ref, FocusNode focusNode) {
    final textTheme = Theme.of(context).textTheme;
    final text = ref.watch(_searchTextProvider.state);
    final isSearched = ref.watch(_isSearchedProvider.state);

    Future<void> search(String query) async {
      isSearched.state = true;
      text.state = query;
    }

    final textController = useTextEditingController();

    return TextField(
      style: textTheme.bodyText2,
      controller: textController,
      focusNode: focusNode,
      onSubmitted: search,
      cursorColor: AppColor.cursor,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            textController.text = '';
          },
          child: const Icon(
            Icons.cancel,
            color: Colors.grey,
          ),
        ),
        hintText: 'リポジトリを検索',
        hintStyle: textTheme.bodyText2?.copyWith(
          color: Colors.grey,
        ),
        isCollapsed: true,
      ),
    );
  }
}
