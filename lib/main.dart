import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/src/common/theme/app_theme.dart';
import 'package:project/src/common/widgets/splash_error_widget.dart';
import 'package:project/src/features/auth/bloc/auth_bloc.dart';
import 'package:project/src/features/auth/data/repositories/auth_repository.dart';
import 'package:project/src/features/auth/ui/screens/create_or_join_family_screen.dart';
import 'package:project/src/features/auth/ui/screens/login_screen.dart';
import 'package:project/src/features/auth/ui/screens/splash_screen.dart';
import 'package:project/src/features/family/data/repositories/family_repository.dart';
import 'package/project/src/features/family/ui/screens/family_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => FamilyRepository()),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
          familyRepository: context.read<FamilyRepository>(),
        )..add(AuthAppStarted()),
        child: MaterialApp(
          title: 'QuickNeeds',
          theme: AppTheme.lightTheme,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return const FamilyDetailsScreen();
              }
              if (state is AuthAuthenticatedWithoutFamily) {
                return const CreateOrJoinFamilyScreen();
              }
              if (state is AuthUnauthenticated || state is AuthRegistrationSuccess) {
                return const LoginScreen();
              }
              if (state is AuthError) {
                return SplashErrorWidget(
                  message: state.message,
                  onRetry: () {
                    context.read<AuthBloc>().add(AuthAppStarted());
                  },
                );
              }
              return const SplashScreen();
            },
          ),
        ),
      ),
    );
  }
}
