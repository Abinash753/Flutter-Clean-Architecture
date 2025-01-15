import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/utils/calcualte_reading_time.dart';
import 'package:flutter_clean_architecture/core/utils/format_date.dart';
import 'package:flutter_clean_architecture/features/blog/domain/entities/blog.dart';

class BlogViewerPage extends StatelessWidget {
  static route(Blog blog) => MaterialPageRoute(
      builder: (context) => BlogViewerPage(
            blog: blog,
          ));
  final Blog blog;
  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text(
                  "by ${blog.posterName}",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  "${formatDateBydMMMYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)}",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(blog.imageUrl),
                ),
                const SizedBox(height: 15),
                Text(blog.content,style:TextStyle(fontSize: 15,height: 2,
                 fontWeight: FontWeight.bold),)
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}
