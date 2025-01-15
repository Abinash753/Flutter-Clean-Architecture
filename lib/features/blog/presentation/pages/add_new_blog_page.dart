import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:flutter_clean_architecture/core/common/widgets/loader.dart';
import 'package:flutter_clean_architecture/core/constants/constants.dart';
import 'package:flutter_clean_architecture/core/theme/app_pallete.dart';
import 'package:flutter_clean_architecture/core/utils/pick_image.dart';
import 'package:flutter_clean_architecture/core/utils/show_snackbar.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/widgets/blog_editor.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopic = [];
  File? image;

  //
  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  //blog upload function
  void uploadBlog() async {
    if (formKey.currentState!.validate() &&
        selectedTopic.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
            BlogUpload(
                content: contentController.text.trim(),
                image: image!,
                posterId: posterId,
                title: titleController.text.trim(),
                topics: selectedTopic),
          );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: uploadBlog, icon: Icon((Icons.done_rounded)))
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.message);
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
                context, BlogPage.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              //5.32 time
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    //upload image section
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                                width: double.infinity,
                                height: 170,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child:
                                        Image.file(image!, fit: BoxFit.cover))),
                          )
                        : GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: DottedBorder(
                              radius: Radius.circular(10),
                              dashPattern: [10, 4],
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              color: AppPallete.borderColor,
                              child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Select Your Image",
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: 15),
                    // list of  blog type
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Constants.topics
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedTopic.contains(e)) {
                                        selectedTopic.remove(e);
                                      } else {
                                        selectedTopic.add(e);
                                      }
                                      setState(() {});
                                      debugPrint(
                                          "selected item ---$selectedTopic");
                                    },
                                    child: Chip(
                                      label: Text(e),
                                      color: selectedTopic.contains(e)
                                          ? WidgetStatePropertyAll(
                                              AppPallete.gradient1)
                                          : null,
                                      side: selectedTopic.contains(e)
                                          ? null
                                          : BorderSide(
                                              color: AppPallete.borderColor),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    //
                    BlogEditor(
                      controller: titleController,
                      hintText: "Blog Title",
                    ),
                    SizedBox(height: 10),
                    //
                    BlogEditor(
                      controller: contentController,
                      hintText: "Blog Content",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
