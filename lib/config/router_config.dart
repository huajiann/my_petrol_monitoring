import 'package:go_router/go_router.dart';
import 'package:my_petrol_monitoring/screens/about/about_screen.dart';
import 'package:my_petrol_monitoring/screens/home/home_screen.dart';
import 'package:my_petrol_monitoring/screens/tools/new_ron95_calculator.dart';
import 'package:my_petrol_monitoring/screens/tools/tools_b_screen.dart';
import '../widgets/main_layout.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/about',
            name: 'about',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const AboutScreen(),
            ),
          ),
          GoRoute(
            path: '/tools/newRon95Calculator',
            name: 'tools-newRon95Calculator',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const NewRon95Calculator(),
            ),
          ),
          GoRoute(
            path: '/tools/b',
            name: 'tools-b',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ToolsBScreen(),
            ),
          ),
        ],
      ),
    ],
  );
}
