import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:github_search/component/app_color.dart';
import 'package:github_search/model/github_repository.dart';
import 'package:github_search/view/repository_detail_page.dart';
import 'package:github_search/view_model/repository_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _elevationProvider = StateProvider<double>((ref) => 0);
final _isInitViewProvider = StateProvider<bool>((ref) => true);
final _loadingProvider = StateProvider<bool>((ref) => false);
final _fetchMoreProvider = StateProvider<bool>((ref) => true);
final _searchTextProvider = StateProvider<String>((ref) => '');
final _pageProvider = StateProvider<int>((ref) => 1);

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final focusNode = useFocusNode();
    final scrollController = useScrollController();
    final elevation = ref.watch(_elevationProvider.state);
    final isInitView = ref.watch(_isInitViewProvider.state);
    final loading = ref.watch(_loadingProvider.state);
    final repositoryNotifier = ref.watch(repositoryNotifierProvider.notifier);
    final repositories = ref.watch(repositoryNotifierProvider);
    final fetchMore = ref.watch(_fetchMoreProvider.state);
    final query = ref.watch(_searchTextProvider.state);
    final page = ref.watch(_pageProvider.state);

    Future<void> listener() async {
      final position = scrollController.position.pixels;
      // スクロールしたらappBarに影をつける
      if (position >= 56) {
        elevation.state = 3;
      } else {
        elevation.state = 0;
      }

      final scrolled = scrollController.position.pixels /
          scrollController.position.maxScrollExtent;
      // 画面の8割りスクロールしたら、追加でデータを読み込む
      if (scrolled > 0.8 && fetchMore.state) {
        page.state++;
        fetchMore.state = false;
        try {
          await repositoryNotifier
              .more(query.state, page: page.state)
              .then((canMore) {
            fetchMore.state = canMore;
          });
        } on Exception {
          // 読み込みエラー時にToastを表示
          await Fluttertoast.showToast(
            msg: '読み込みの上限に達しました。\n1分後に再度検索してください。',
            timeInSecForIosWeb: 3,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black38,
          );
        }
      }
    }

    useEffect(() {
      scrollController.addListener(listener);
      return () {
        scrollController.removeListener(listener);
      };
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
              _body(
                isInit: isInitView.state,
                loading: loading.state,
                textTheme: textTheme,
                repositories: repositories,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body({
    required bool isInit,
    required bool loading,
    required TextTheme textTheme,
    required List<GithubRepository> repositories,
  }) {
    // 初期画面
    if (isInit) {
      return _buildInitView();
    }

    if (loading) {
      return _buildLoadingView(textTheme);
    }

    if (repositories.isEmpty) {
      return _buildRepositoryEmptyView(textTheme);
    }

    return _buildRepositories(repositories, textTheme);
  }

  SliverList _buildRepositories(
      List<GithubRepository> repositories, TextTheme textTheme) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _sliverItem(context, repositories, index, textTheme);
        },
        childCount: repositories.length,
      ),
    );
  }

  Card _sliverItem(BuildContext context, List<GithubRepository> repositories,
      int index, TextTheme textTheme) {
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
  }

  SliverFillRemaining _buildRepositoryEmptyView(TextTheme textTheme) {
    return SliverFillRemaining(
      child: Center(
        child: Text(
          '該当のリポジトリは見つかりませんでした。',
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
    final isInitView = ref.watch(_isInitViewProvider.state);
    final loading = ref.watch(_loadingProvider.state);
    final repositoryNotifier = ref.watch(repositoryNotifierProvider.notifier);
    final page = ref.watch(_pageProvider.state);
    final query = ref.watch(_searchTextProvider.state);

    Future<void> search(String text) async {
      query.state = text;
      loading.state = true;
      page.state = 1;
      isInitView.state = false;
      try {
        await repositoryNotifier.init(query.state);
      } on Exception {
        await Fluttertoast.showToast(
          msg: 'データを取得できませんでした。',
          timeInSecForIosWeb: 3,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black38,
        );
      }
      loading.state = false;
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
