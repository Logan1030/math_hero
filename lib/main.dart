import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'presentation/providers/game_provider.dart';

void main() {
  runApp(const MathHeroApp());
}

class MathHeroApp extends StatelessWidget {
  const MathHeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp.router(
        title: '数学小英雄',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
