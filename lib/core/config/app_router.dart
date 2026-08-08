import 'dart:async';

import 'package:final_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:final_project/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:final_project/features/auth/presentation/pages/login_page.dart';
import 'package:final_project/features/auth/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/splash_page.dart';

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(Stream<AuthState> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  AppRouter._();

  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: GoRouterRefreshNotifier(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;

        if (authState is AuthInitial || authState is AuthLoading) {
          return state.matchedLocation == '/' ? null : '/';
        }

        if (authState is Unauthenticated) {
          final isAuthPage =
              state.matchedLocation == '/login' ||
              state.matchedLocation == '/register' ||
              state.matchedLocation == '/forgot-password';

          return isAuthPage ? null : '/login';
        }

        if (authState is Authenticated) {
          final isAuthPage =
              state.matchedLocation == '/login' ||
              state.matchedLocation == '/register' ||
              state.matchedLocation == '/forgot-password';

          if (isAuthPage || state.matchedLocation == '/') {
            if (authState.user.role == 'admin') {
              return '/admin';
            }

            return '/customer';
          }
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/forgot-password',
          name: 'forgot-password',
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: '/customer',
          name: 'customer',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Customer'))),
        ),

        GoRoute(
          path: '/admin',
          name: 'admin',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Admin'))),
        ),
      ],
    );
  }
}
