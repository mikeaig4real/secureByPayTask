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

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  late final TapGestureRecognizer _loginRecognizer;

  @override
  void initState() {
    super.initState();
    _loginRecognizer = TapGestureRecognizer()
      ..onTap = () => Navigator.of(context).pushReplacementNamed('/signin');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _loginRecognizer.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final authStore = context.read<AuthStore>();
    final success = await authStore.register(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    if (mounted) {
      if (success) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authStore.errorMessage ?? 'Registration failed'),
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
                  'Create an account',
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
                            'Sign up for Myafrimall and gain unlimited access to shipping to over 300 countries from Nigeria. Do you already have an account? ',
                      ),
                      TextSpan(
                        text: 'Login',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5A65AB),
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: _loginRecognizer,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'First name',
                        hintText: 'John',
                        controller: _firstNameController,
                        validator: (val) =>
                            (val == null || val.trim().isEmpty) ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppTextField(
                        label: 'Last name',
                        hintText: 'Doe',
                        controller: _lastNameController,
                        validator: (val) =>
                            (val == null || val.trim().isEmpty) ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

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
                  label: 'Phone Number',
                  hintText: '8012345678',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixWidget: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '+234',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF344054),
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: Color(0xFF667085),
                        ),
                        Container(
                          width: 1,
                          height: 20,
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          color: const Color(0xFFD0D5DD),
                        ),
                      ],
                    ),
                  ),
                  validator: (val) =>
                      (val == null || val.trim().isEmpty) ? 'Phone number is required' : null,
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
                const SizedBox(height: 26),

                Align(
                  alignment: Alignment.centerLeft,
                  child: AppButton(
                    text: 'Create account',
                    width: 160,
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
                    title: 'Seamlessly Delivering to Over 300\nCountries from Nigeria!',
                    subtitle:
                        'Access global markets with our quick shipping from Nigeria! Fast delivery and easy customs to 300+ countries.',
                  ),
                ),
              ],
            )
          : formContent,
    );
  }
}
