import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/common/widgets/loader.dart';
import 'package:flutter_clean_architecture/core/theme/app_pallete.dart';
import 'package:flutter_clean_architecture/core/utils/show_snackbar.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/pages/blog_page.dart';
import 'package:get/get.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              return const Loader();
            }
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign Up",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
                    ),
                    const SizedBox(height: 15),
                    AuthField(
                      hintText: "Name",
                      controller: nameController,
                    ),
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
                      buttonText: "Sign Up",
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          debugPrint(
                              "User ifno ${nameController.text}, ${emailController.text} ${passwordController.text}");
                          
                            context.read<AuthBloc>().add(AuthSignUp(
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim()));
                       
                        }
                        debugPrint("called");
                      },
                    ),
                    GestureDetector(
                      onTap: () => Get.to(LoginPage()),
                      child: RichText(
                        text: TextSpan(
                            text: "Already have an account? ",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: "Login",
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
              ),
            );
          },
        ),
      ),
    );
  }
}
