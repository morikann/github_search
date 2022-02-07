import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_search/component/app_color.dart';
import 'package:github_search/view/home_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColor.main,
          secondary: AppColor.accent,
          onPrimary: AppColor.text,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F8FA),
        textTheme: TextTheme(
          headline6: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          subtitle1: TextStyle(
            color: AppColor.text,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            color: AppColor.text,
            fontSize: 16,
          ),
          bodyText2: TextStyle(
            color: AppColor.text,
            // textBaseline: TextBaseline.values,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        iconTheme: IconThemeData(
          color: AppColor.text,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColor.text,
          secondary: AppColor.accent,
          onPrimary: AppColor.main,
        ),
        textTheme: TextTheme(
          headline6: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          subtitle1: TextStyle(
            color: AppColor.text,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            color: AppColor.main,
            fontSize: 16,
          ),
          bodyText2: TextStyle(
            color: AppColor.text,
            // textBaseline: TextBaseline.values,
          ),
        ),
        scaffoldBackgroundColor: AppColor.back,
      ),
      home: const HomePage(),
    );
  }
}
