import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _elevationProvider = StateProvider<double>((ref) => 0);

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final scrollController = useScrollController();
    final elevation = ref.watch(_elevationProvider.state);

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
        title: const Text('ホーム'),
      ),
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: focusNode.unfocus,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                flexibleSpace: FlexibleSpaceBar(
                  title: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: _buildTextField(focusNode),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField _buildTextField(FocusNode focusNode) {
    return TextField(
      focusNode: focusNode,
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
        suffixIcon: const Icon(
          Icons.cancel,
          color: Colors.grey,
        ),
        hintText: 'リポジトリを検索',
        isCollapsed: true,
      ),
    );
  }
}
