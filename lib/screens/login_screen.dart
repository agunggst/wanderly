import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:wanderly/screens/home_screen.dart';
import 'package:wanderly/screens/register_screen.dart';
import 'package:wanderly/style/app_text.dart';
import 'package:wanderly/widgets/custom_text_input.dart';
import 'package:wanderly/widgets/link_button.dart';
import 'package:wanderly/widgets/or_divider.dart';
import 'package:wanderly/widgets/primary_button.dart';
import 'package:wanderly/widgets/social_auth_button.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      setState(() {
        emailError = "Email is required";
      });
      return false;
    }
    if (!usernameEmailController.text.contains('@')) {
      setState(() {
        emailError = "Please use email format";
      });
      return false;
    }
    setState(() {
      emailError = "";
    });
    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = "Password is required";
      });
      return false;
    }
    return true;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.w),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Adaptive.sh(4),),
              ClipRRect(
                child: Image.asset(
                  'assets/wanderly_logo.png',
                  width: Adaptive.w(50),
                ),
              ),
              SizedBox(height: Adaptive.sh(4),),
              Text(
                "Welcome",
                style: AppTextStyles.heading(context),
              ),
              Text(
                "Your Next adventure is just a login away.",
                style: AppTextStyles.caption(context),
              ),
              SizedBox(height: Adaptive.sh(4),),
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
                    SizedBox(height: Adaptive.sh(0.5),),
                    CustomTextInput(
                      label: 'Password',
                      hint: '************',
                      controller: passwordController,
                      icon: Icons.lock_outline,
                      errorText: passwordError,
                      isPassword: true,
                    ),
                    SizedBox(height: Adaptive.sh(4),),
                    PrimaryButton(
                      label: 'Login', 
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        if (formValidate()) {
                          setState(() {
                            emailError = '';
                            passwordError = '';
                          });
                          context.go(HomeScreen.routeName);
                        }
                      }
                    ),
                    SizedBox(height: Adaptive.sh(2),),
                  ],
                )
              ),
              const OrDivider(),
              SizedBox(height: Adaptive.sh(2),),
              SocialAuthButton(
                label: 'Sign in with Google',
                svgAsset: 'assets/google.svg',
                onPressed: () {},
              ),
              SizedBox(height: Adaptive.sh(2),),
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
                    }
                  )
                ],
              )
            ],
          ),
        )
      )
    );
  }
}