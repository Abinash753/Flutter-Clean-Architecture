import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/common/widgets/loader.dart';
import 'package:flutter_clean_architecture/core/secrets/app_secrets.dart';
import 'package:flutter_clean_architecture/core/theme/app_pallete.dart';
import 'package:flutter_clean_architecture/core/utils/show_snackbar.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/widgets/blog_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  //logout
  Future<void> signOut() async {
    debugPrint("signout called");
    final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl,
      anonKey: AppSecrets.supabaseAnnonKey,
    );
    try {
      supabase.client.auth.signOut();
      debugPrint("signout successful");
      Navigator.pushAndRemoveUntil(
          context, LoginPage.route(), (route) => false);
    } catch (e) {
      debugPrint('ERROR SIGN OUT $e');
      debugPrint('ERROR SIGN OUT $e');
      debugPrint('ERROR SIGN OUT $e');
      throw 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog App"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              debugPrint("hello");
              debugPrint("hello");
              debugPrint("hello");
              debugPrint("hello");
              signOut();
              // Navigator.push(context, AddNewBlogPage.route());
            },
            icon: const Icon(
              Icons.logout_rounded,
            )),
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogDisplaySuccess) {
            return ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  final blog = state.blogs[index];
                  return BlogCard(
                    blog: blog,
                    color: index % 3 == 0
                        ? AppPallete.gradient1
                        : index % 3 == 1
                            ? AppPallete.gradient2
                            : AppPallete.gradient3,
                  );
                });
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, AddNewBlogPage.route());
          },
          child: const Icon(CupertinoIcons.add_circled)),
    );
  }
}
