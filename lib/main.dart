import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/src/common/theme/app_theme.dart';
import 'package:project/src/common/widgets/splash_error_widget.dart';
import 'package:project/src/features/auth/bloc/auth_bloc.dart';
import 'package:project/src/features/auth/ui/screens/create_or_join_family_screen.dart';
import 'package:project/src/features/auth/ui/screens/login_screen.dart';
import 'package:project/src/features/auth/ui/screens/registration_success_screen.dart';
import 'package:project/src/features/auth/ui/screens/splash_screen.dart';
import 'package:project/src/features/home/ui/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(AuthAppStarted()),
      child: MaterialApp(
        title: 'QuickNeeds',
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const HomeScreen();
            }
            if (state is AuthAuthenticatedWithoutFamily) {
              return const CreateOrJoinFamilyScreen();
            }
            if (state is AuthUnauthenticated) {
              return const LoginScreen();
            }
            if (state is AuthRegistrationSuccess) {
              return const RegistrationSuccessScreen();
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
    );
  }
}
