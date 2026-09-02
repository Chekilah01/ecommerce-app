import 'dart:async';

import 'package:final_project/features/admin/presentation/pages/add_product_page.dart';
import 'package:final_project/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:final_project/features/admin/presentation/pages/admin_orders_page.dart';
import 'package:final_project/features/admin/presentation/pages/admin_products_page.dart';
import 'package:final_project/features/admin/presentation/pages/admin_profile_page.dart';
import 'package:final_project/features/admin/presentation/pages/admin_shell_page.dart';
import 'package:final_project/features/admin/presentation/pages/edit_product_page.dart';
import 'package:final_project/features/admin/presentation/pages/edit_profile_page.dart';
import 'package:final_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:final_project/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:final_project/features/auth/presentation/pages/login_page.dart';
import 'package:final_project/features/auth/presentation/pages/register_page.dart';
import 'package:final_project/features/customer/presentation/pages/cart_page.dart';
import 'package:final_project/features/customer/presentation/pages/customer_shell_page.dart';
import 'package:final_project/features/customer/presentation/pages/home_page.dart';
import 'package:final_project/features/customer/presentation/pages/orders_page.dart';
import 'package:final_project/features/customer/presentation/pages/product_details_page.dart';
import 'package:final_project/features/customer/presentation/pages/profile_page.dart';
import 'package:final_project/features/customer/presentation/pages/search_page.dart';
import 'package:final_project/features/product/domain/entities/product_entity.dart';
import 'package:final_project/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

        if (authState is AuthInitial) {
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
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return BlocProvider(
              create: (context) => ProductBloc(),
              child: CustomerShellPage(navigationShell: navigationShell),
              );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/customer',
                  name: 'customer-home',
                  builder: (context, state) => const HomePage(),
                ),
              ],
            ),

            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/customer/search',
                  name: 'customer-search',
                  builder: (context, state) => const CustomerSearchPage(),
                  routes: [
                    GoRoute(
                      path: 'product-details',
                      name: 'customer-product-details',
                      builder: (context, state) {
                        final product = state.extra as ProductEntity;

                        return ProductDetailsPage(product : product);
                      },
                    ),
                  ]
                ),
              ],
            ),

            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/customer/cart',
                  name: 'customer-cart',
                  builder: (context, state) => const CartPage(),
                ),
              ],
            ),

            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/customer/orders',
                  name: 'customer-orders',
                  builder: (context, state) => const OrdersPage(),
                ),
              ],
            ),

            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/customer/profile',
                  name: 'customer-profile',
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),
          ],
        ),

        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return BlocProvider(
              create: (context) => ProductBloc(),
              child: AdminShellPage(navigationShell: navigationShell),
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/admin',
                  name: 'admin-dashboard',
                  builder: (context, state) => const AdminDashboardPage(),
                ),
              ],
            ),

            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/admin/products',
                  name: 'admin-products',
                  builder: (context, state) {
                    return const AdminProductsPage();
                  },
                  routes: [
                    GoRoute(
                      path: 'add',
                      name: 'admin-add-product',
                      builder: (context, state) {
                        return const AddProductPage();
                      },
                    ),
                    GoRoute(
                      path: 'edit',
                      name: 'admin-edit-product',
                      builder: (context, state) {
                        final product = state.extra as ProductEntity;

                        return EditProductPage(product: product);
                      },
                    ),
                  ],
                ),
              ],
            ),

            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/admin/orders',
                  name: 'admin-orders',
                  builder: (context, state) => const AdminOrdersPage(),
                ),
              ],
            ),

            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/admin/profile',
                  name: 'admin-profile',
                  builder: (context, state) => const AdminProfilePage(),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      name: 'admin-edit-profile',
                      builder: (context, state) => const EditProfilePage(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
