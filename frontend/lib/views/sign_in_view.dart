import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/responsive.dart';
import '../../stores/auth_store.dart';
import '../components/pure/app_button.dart';
import '../components/pure/app_text_field.dart';
import '../components/pure/auth_hero_banner.dart';
import '../components/pure/auth_legal_footer.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final TapGestureRecognizer _signUpRecognizer;

  @override
  void initState() {
    super.initState();
    _signUpRecognizer = TapGestureRecognizer()
      ..onTap = () => Navigator.of(context).pushReplacementNamed('/signup');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _signUpRecognizer.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final authStore = context.read<AuthStore>();
    final success = await authStore.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (mounted) {
      if (success) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authStore.errorMessage ?? 'Invalid login credentials'),
            backgroundColor: const Color(0xFFD92D20),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStore = context.watch<AuthStore>();
    final isDesktopOrTablet = !Responsive.isMobile(context);

    final formContent = Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sign in to your account',
                  style: GoogleFonts.dmSans(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF171717),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),

                RichText(
                  text: TextSpan(
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: const Color(0xFF525252),
                      height: 1.45,
                    ),
                    children: [
                      const TextSpan(
                        text:
                            'Log in to Myafrimall to enjoy seamless shipping to over 300\ncountries right from Nigeria.. Don\'t have an account yet? ',
                      ),
                      TextSpan(
                        text: 'Sign Up',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5A65AB),
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: _signUpRecognizer,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                AppTextField(
                  label: 'Email',
                  hintText: 'user@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Email is required';
                    if (!val.contains('@') || !val.contains('.')) return 'Enter valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                AppTextField(
                  label: 'Password',
                  hintText: 'Enter Password',
                  controller: _passwordController,
                  isPassword: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Password is required';
                    if (val.length < 6) return 'Must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF5A65AB),
                    ),
                  ),
                ),
                const SizedBox(height: 26),

                Align(
                  alignment: Alignment.centerLeft,
                  child: AppButton(
                    text: 'Login',
                    width: 110,
                    height: 48,
                    isLoading: authStore.isLoading,
                    onPressed: _submit,
                  ),
                ),
                const SizedBox(height: 24),

                const AuthLegalFooter(),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: isDesktopOrTablet
          ? Row(
              children: [
                Expanded(flex: 5, child: formContent),
                const Expanded(
                  flex: 5,
                  child: AuthHeroBanner(
                    title: 'Effortlessly Track Your Shipments\nfrom Nigeria!',
                    subtitle:
                        'Monitor your shipments from Nigeria! Enjoy swift delivery and\nseamless customs processing',
                  ),
                ),
              ],
            )
          : formContent,
    );
  }
}
