import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import 'package:wanderly/features/trip/view/screens/home_screen.dart';
import 'package:wanderly/features/auth/view/screens/login_screen.dart';
import 'package:wanderly/features/auth/provider/auth_provider.dart';

import 'package:wanderly/core/theme/app_text.dart';
import 'package:wanderly/features/user/data/user_model.dart';
import 'package:wanderly/features/user/provider/user_provider.dart';
import 'package:wanderly/shared/widgets/custom_text_input.dart';
import 'package:wanderly/shared/widgets/link_button.dart';
import 'package:wanderly/shared/widgets/or_divider.dart';
import 'package:wanderly/shared/widgets/primary_button.dart';
import 'package:wanderly/features/auth/view/widgets/social_auth_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const routeName = "/register";

  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  String nameError = "";

  final emailController = TextEditingController();
  String emailError = "";

  final passwordController = TextEditingController();
  String passwordError = "";

  bool _isLoading = false;

  bool formValidate() {
    nameError = "";
    emailError = "";
    passwordError = "";

    if (nameController.text.isEmpty) {
      nameError = "Name is required";
      return false;
    }

    if (emailController.text.isEmpty) {
      emailError = "Email is required";
      return false;
    }

    if (!emailController.text.contains('@')) {
      emailError = "Please use email format";
      return false;
    }

    if (passwordController.text.isEmpty) {
      passwordError = "Password is required";
      return false;
    }

    if (passwordController.text.length < 6) {
      passwordError = "Password must be at least 6 characters";
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Adaptive.sh(4)),

              Image.asset(
                'assets/wanderly_logo.png',
                width: Adaptive.w(30),
              ),

              SizedBox(height: Adaptive.sh(2)),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Create Account",
                      style: AppTextStyles.heading(context)),
                  Text(
                    "Start your next journey with us.",
                    style: AppTextStyles.caption(context),
                  ),
                ],
              ),

              SizedBox(height: Adaptive.sh(2)),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextInput(
                      label: 'Full Name',
                      hint: 'John Smith',
                      controller: nameController,
                      icon: Icons.person,
                      errorText: nameError,
                    ),
                    SizedBox(height: Adaptive.sh(0.5)),

                    CustomTextInput(
                      label: 'Email',
                      hint: 'e.g. wanderer@travel.com',
                      controller: emailController,
                      icon: Icons.person_outline,
                      errorText: emailError,
                    ),
                    SizedBox(height: Adaptive.sh(0.5)),

                    CustomTextInput(
                      label: 'Password',
                      hint: '************',
                      controller: passwordController,
                      icon: Icons.lock_outline,
                      errorText: passwordError,
                      isPassword: true,
                    ),

                    SizedBox(height: Adaptive.sh(2)),

                    PrimaryButton(
                      label: _isLoading ? 'Creating Account...' : 'Create Account',
                      onPressed: _isLoading ? null : () async {
                        if (!formValidate()) {
                          setState(() {});
                          return;
                        }

                        setState(() => _isLoading = true);

                        try {
                          // Register with Firebase
                          await ref.read(authProvider.notifier).register(
                            email: emailController.text,
                            password: passwordController.text,
                            fullName: nameController.text,
                          );

                          // Set user data
                          ref.read(userProvider.notifier).setUser(
                            User(
                              email: emailController.text,
                              password: passwordController.text,
                              fullName: nameController.text,
                            ),
                          );

                          // Navigate to home
                          if (mounted) {
                            context.go(HomeScreen.routeName);
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() => _isLoading = false);
                          }
                        }
                      },
                    ),

                    SizedBox(height: Adaptive.sh(2)),
                  ],
                ),
              ),

              const OrDivider(text: 'OR'),
              SizedBox(height: Adaptive.sh(2)),

              SocialAuthButton(
                label: 'Sign up with Google',
                svgAsset: 'assets/google.svg',
                onPressed: () {},
              ),

              SizedBox(height: Adaptive.sh(2)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTextStyles.body(context),
                  ),
                  LinkButton(
                    text: "Login",
                    onPressed: () {
                      context.push(LoginScreen.routeName);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
