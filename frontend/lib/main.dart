import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'stores/auth_store.dart';
import 'stores/dashboard_store.dart';
import 'views/sign_in_view.dart';
import 'views/sign_up_view.dart';
import 'views/dashboard_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SecureByPayApp());
}

class SecureByPayApp extends StatelessWidget {
  const SecureByPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthStore()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardStore(),
        ),
      ],
      child: MaterialApp(
        title: 'SecureByPay - Logistics & Payments',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthGate(),
        routes: {
          '/signin': (_) => const SignInView(),
          '/signup': (_) => const SignUpView(),
          '/dashboard': (_) => const DashboardView(),
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authStore = context.watch<AuthStore>();

    if (!authStore.isInitialized) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              SizedBox(height: 16),
              Text(
                'Initializing SecureByPay...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (authStore.isAuthenticated) {
      return const DashboardView();
    }

    return const SignInView();
  }
}
