import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/workout_screen.dart';
import 'screens/exercise_list_screen.dart';
import 'screens/workout_log_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/invite_friends_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/friend_requests_screen.dart';
import 'screens/ai_assistant_chat_screen.dart';
import 'screens/training_program_selector_screen.dart';
import '../models/training_program.dart';
import 'screens/program_muscle_map_screen.dart';
import 'screens/custom_workout_creator_screen.dart';
import 'screens/bodyweight_cardio_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const GymProgressTrackerApp());
}

class GymProgressTrackerApp extends StatelessWidget {
  const GymProgressTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: MaterialApp.router(
        title: 'Gym Progress Tracker',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        locale: const Locale('en'),
        initialLocation: '/choose',
        routerConfig: _routerConfig,
      ),
    );
  }

  final GoRouter _routerConfig = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (c,s)=> const _AuthWrapper()),
      GoRoute(path: '/login', builder: (c,s)=> const LoginScreen()),
      GoRoute(path: '/signup', builder: (c,s)=> const SignUpScreen()),
      GoRoute(path: '/home', builder: (c,s)=> const HomeScreen()),
      GoRoute(path: '/workout', builder: (c,s)=> const WorkoutScreen()),
      GoRoute(path: '/exerciseList', builder: (c,s){
        final category = ModalRoute.of(c.context)!.settings.arguments as String;
        return ExerciseListScreen(category: category);
      }),
      GoRoute(path: '/workoutLog', builder: (c,s){
        final exercise = ModalRoute.of(c.context)!.settings.arguments as String;
        return WorkoutLogScreen(exercise: exercise);
      }),
      GoRoute(path: '/profile', builder: (c,s)=> const ProfileScreen()),
      GoRoute(path: '/chat', builder: (c,s){
        final name = ModalRoute.of(c.context)!.settings.arguments as String;
        return ChatScreen(friendName: name);
      }),
      GoRoute(path: '/inviteFriends', builder: (c,s)=> const InviteFriendsScreen()),
      GoRoute(path: '/leaderboard', builder: (c,s)=> const LeaderboardScreen()),
      GoRoute(path: '/friendRequests', builder: (c,s)=> const FriendRequestsScreen()),
      GoRoute(path: '/aiChat', builder: (c,s)=> const AiAssistantChatScreen()),
      GoRoute(path: '/choose', builder: (c,s)=> const TrainingProgramSelectorScreen()),
      GoRoute(path: '/program/:prog', builder: (c, s){
        final p = TrainingProgram.values.byName(s.params['prog']!);
        // For now navigate to Home or muscle map placeholder
        return ExerciseListScreen(method: TrainingMethod.chest); // placeholder
      }),
      GoRoute(path: '/muscles/:prog', builder: (c,s){
        final p = TrainingProgram.values.byName(s.params['prog']!);
        return ProgramMuscleMapScreen(program: p);
      }),
      GoRoute(path: '/customWorkout/new', builder: (c,s)=> const CustomWorkoutCreatorScreen()),
      GoRoute(path: '/bodyweight', builder: (c,s)=> const BodyweightAndCardioScreen()),
    ],
  );
}

class _AuthWrapper extends StatelessWidget {
  const _AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    if (user != null) {
      return const HomeScreen();
    }
    return const LoginScreen();
  }
} 