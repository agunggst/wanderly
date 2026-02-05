import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import 'package:wanderly/features/trip/view/screens/home_screen.dart';
import 'package:wanderly/features/auth/view/screens/register_screen.dart';
import 'package:wanderly/features/auth/provider/auth_provider.dart';

import 'package:wanderly/core/theme/app_text.dart';
import 'package:wanderly/features/user/data/user_model.dart';
import 'package:wanderly/features/user/provider/user_provider.dart';
import 'package:wanderly/shared/widgets/custom_text_input.dart';
import 'package:wanderly/shared/widgets/link_button.dart';
import 'package:wanderly/shared/widgets/or_divider.dart';
import 'package:wanderly/shared/widgets/primary_button.dart';
import 'package:wanderly/features/auth/view/widgets/social_auth_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = "/login";

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameEmailController = TextEditingController();
  String emailError = "";

  final passwordController = TextEditingController();
  String passwordError = "";

  bool formValidate() {
    setState(() {
      passwordError = "";
      emailError = "";
    });

    if (usernameEmailController.text.isEmpty) {
      emailError = "Email is required";
      return false;
    }

    if (!usernameEmailController.text.contains('@')) {
      emailError = "Please use email format";
      return false;
    }

    if (passwordController.text.isEmpty) {
      passwordError = "Password is required";
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    usernameEmailController.dispose();
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
            children: [
              SizedBox(height: Adaptive.sh(4)),
              Image.asset(
                'assets/wanderly_logo.png',
                width: Adaptive.w(50),
              ),
              SizedBox(height: Adaptive.sh(4)),

              Text("Welcome", style: AppTextStyles.heading(context)),
              Text(
                "Your Next adventure is just a login away.",
                style: AppTextStyles.caption(context),
              ),

              SizedBox(height: Adaptive.sh(4)),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextInput(
                      label: 'Email',
                      hint: 'e.g. wanderer@travel.com',
                      controller: usernameEmailController,
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

                    SizedBox(height: Adaptive.sh(4)),

                    PrimaryButton(
                      label: 'Login',
                      icon: Icons.arrow_forward,
                      onPressed: () async {
                        if (!formValidate()) {
                          setState(() {});
                          return;
                        }

                        // =========================
                        // SIMULASI LOGIN SUCCESS
                        // =========================
                        const token = "token_from_server";

                        // SET TOKEN KE RIVERPOD
                        await ref.read(authProvider.notifier).login(token);

                        // SET USER DATA
                        ref.read(userProvider.notifier).setUser(
                          User(
                            email: usernameEmailController.text,
                            password: passwordController.text,
                            fullName: "Guest User", // dari API nanti
                          ),
                        );
                      },
                    ),

                    SizedBox(height: Adaptive.sh(2)),
                  ],
                ),
              ),

              const OrDivider(),
              SizedBox(height: Adaptive.sh(2)),

              SocialAuthButton(
                label: 'Sign in with Google',
                svgAsset: 'assets/google.svg',
                onPressed: () {},
              ),

              SizedBox(height: Adaptive.sh(2)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have account? ',
                    style: AppTextStyles.body(context),
                  ),
                  LinkButton(
                    text: "Register Now",
                    onPressed: () {
                      context.push(RegisterScreen.routeName);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
