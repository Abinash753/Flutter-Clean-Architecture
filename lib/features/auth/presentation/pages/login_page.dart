import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/common/widgets/loader.dart';
import 'package:flutter_clean_architecture/core/theme/app_pallete.dart';
import 'package:flutter_clean_architecture/core/utils/show_snackbar.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/pages/blog_page.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
   static route() => MaterialPageRoute(builder: (context) => LoginPage());
 
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar(context, state.message);
            }
          else  if (state is AuthFailure) {
              Navigator.pushAndRemoveUntil(
                  context, BlogPage.route(), (route) => false);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Loader();
            }
            return Form(
              key: formKey,
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
                  ),
                  const SizedBox(height: 15),
                  AuthField(
                    hintText: "Email",
                    controller: emailController,
                  ),
                  AuthField(
                    hintText: "Password",
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  const SizedBox(height: 5),
                  AuthGradientButton(
                    buttonText: "Login",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              AuthLogin(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim()),
                            );
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: () => Get.to(SignupPage()),
                    child: RichText(
                      text: TextSpan(
                          text: "Don't have an account? ",
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: "Sign In",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: AppPallete.gradient2,
                                      fontWeight: FontWeight.bold),
                            )
                          ]),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
