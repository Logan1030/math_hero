import 'package:go_router/go_router.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/world_map_screen.dart';
import '../../presentation/screens/quiz_screen.dart';
import '../../presentation/screens/result_screen.dart';
import '../../presentation/screens/stars_screen.dart';
import '../../presentation/screens/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/world-map',
      builder: (context, state) => const WorldMapScreen(),
    ),
    GoRoute(
      path: '/quiz/:levelId',
      builder: (context, state) {
        final levelId = int.parse(state.pathParameters['levelId']!);
        return QuizScreen(levelId: levelId);
      },
    ),
    GoRoute(
      path: '/result/:levelId',
      builder: (context, state) {
        final levelId = int.parse(state.pathParameters['levelId']!);
        return ResultScreen(levelId: levelId);
      },
    ),
    GoRoute(
      path: '/stars',
      builder: (context, state) => const StarsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
