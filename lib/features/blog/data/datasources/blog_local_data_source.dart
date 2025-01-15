import 'package:flutter_clean_architecture/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBLog({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl(this.box);
  @override
  List<BlogModel> blogs = [];
  @override
  List<BlogModel> loadBlogs() {
    for (int i = 0; i < box.length; i++) {
      blogs.add(
        BlogModel.fromJson(
          box.get(
            i.toString(),
          ),
        ),
      );
    }
    return blogs;
  }

  @override
  void uploadLocalBLog({required List<BlogModel> blogs}) {
    box.clear();

    for (int i = 0; i < blogs.length; i++) {
      box.put(i.toString(), blogs[i].toJson());
    }
  }
}
