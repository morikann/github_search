import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_search/view/home_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  // 指定のpathを表示しているAssetImageを見つける
  // Finder findByAssetImage(String path) {
  //   final finder = find.byWidgetPredicate((Widget widget) {
  //     if (widget is Image && widget.image is AssetImage) {
  //       final assetImage = widget.image as AssetImage;
  //       return assetImage.keyName == path;
  //     }
  //     return false;
  //   });
  //   return finder;
  // }
  //
  // group('home_page', () {
  //   testWidgets('has a AssetImage', (WidgetTester tester) async {
  //     await tester.pumpWidget(
  //       const ProviderScope(
  //         child: MaterialApp(
  //           home: HomePage(),
  //         ),
  //       ),
  //     );
  //     final encourageSearchText = find.text('リポジトリを検索してみよう！');
  //
  //     expect(encourageSearchText, findsOneWidget);
  //   });
  // });
}
