import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:wanderly/screens/home_screen.dart';
import 'package:wanderly/screens/login_screen.dart';
import 'package:wanderly/style/app_text.dart';
import 'package:wanderly/widgets/custom_text_input.dart';
import 'package:wanderly/widgets/link_button.dart';
import 'package:wanderly/widgets/or_divider.dart';
import 'package:wanderly/widgets/primary_button.dart';
import 'package:wanderly/widgets/social_auth_button.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = "/register";
  
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  String nameError = "";

  final emailController = TextEditingController();
  String emailError = "";

  final passwordController = TextEditingController();
  String passwordError = "";

  bool formValidate() {
    setState(() {
      nameError = "";
      passwordError = "";
      emailError = "";
    });
    if (nameController.text.isEmpty) {
      setState(() {
        nameError = "Name is required";
      });
      return false;
    }
    setState(() {
      nameError = "";
    });
    if (emailController.text.isEmpty) {
      setState(() {
        emailError = "Email is required";
      });
      return false;
    }
    if (!emailController.text.contains('@')) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Adaptive.sh(4),),
              ClipRRect(
                child: Image.asset(
                  'assets/wanderly_logo.png',
                  width: Adaptive.w(30),
                ),
              ),
              SizedBox(height: Adaptive.sh(2),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Account",
                    style: AppTextStyles.heading(context),
                  ),
                  Text(
                    "Start your next journey with us.",
                    style: AppTextStyles.caption(context),
                  ),
                ],
              ),
              SizedBox(height: Adaptive.sh(2),),
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
                    SizedBox(height: Adaptive.sh(0.5),),
                    CustomTextInput(
                      label: 'Email',
                      hint: 'e.g. wanderer@travel.com',
                      controller: emailController,
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
                    SizedBox(height: Adaptive.sh(2),),
                    PrimaryButton(
                      label: 'Create Account',
                      onPressed: () {
                        if (formValidate()) {
                          setState(() {
                            nameError = '';
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
              const OrDivider(text: 'OR',),
              SizedBox(height: Adaptive.sh(2),),
              SocialAuthButton(
                label: 'Sign up with Google',
                svgAsset: 'assets/google.svg',
                onPressed: () {},
              ),
              SizedBox(height: Adaptive.sh(2),),
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
                    }
                  )
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}