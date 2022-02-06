import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:github_search/model/github_repository.dart';
import 'package:github_search/service/github_client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _elevationProvider = StateProvider<double>((ref) => 0);
final _searchTextProvider = StateProvider<String>((ref) => '');
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
    final focusNode = useFocusNode();
    final scrollController = useScrollController();
    final elevation = ref.watch(_elevationProvider.state);
    final repositories = ref.watch(_repositoryProvider);

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
        elevation: elevation.state,
        title: const Text(
          'ホーム',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
                  title: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: _buildTextField(context, ref, focusNode),
                  ),
                ),
              ),
              repositories.when(
                loading: () => SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/github_icon.png',
                          height: 100,
                        ),
                        const Text('loading...'),
                      ],
                    ),
                  ),
                ),
                error: (error, stack) {
                  print(error);
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text('データを取得できませんでした。'),
                    ),
                  );
                },
                data: (repositories) {
                  if (repositories.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Text('該当のリポジトリはありませんでした。'),
                      ),
                    );
                  } else {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Text(repositories[index].name!),
                            ),
                          );
                        },
                        childCount: repositories.length,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context, WidgetRef ref, FocusNode focusNode) {
    final text = ref.watch(_searchTextProvider.state);

    Future<void> search(String query) async {
      text.state = query;
    }

    final textController = useTextEditingController();

    return TextField(
      controller: textController,
      focusNode: focusNode,
      onSubmitted: search,
      cursorColor: Colors.blue,
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
        isCollapsed: true,
      ),
    );
  }
}
