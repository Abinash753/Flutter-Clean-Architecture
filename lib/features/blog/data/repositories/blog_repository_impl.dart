import 'dart:io';

import 'package:flutter_clean_architecture/core/constants/constants.dart';
import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/network/connection_checker.dart';
import 'package:flutter_clean_architecture/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:flutter_clean_architecture/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/blog/data/models/blog_model.dart';
import 'package:flutter_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:flutter_clean_architecture/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
// import 'package:fpdart/src/either.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    this.blogLocalDataSource,
    this.connectionChecker,
  );
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(
          Failure(Constants.noConnectionErrorMessage),
        );
      }
      BlogModel blogModel = BlogModel(
        id: Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: "imageUrl",
        topics: topics,
        updatedAt: DateTime.now(),
      );
      final imageUrl = await blogRemoteDataSource.uploadImage(
        image: image,
        blog: blogModel,
      );
      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);

      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBLog(blogs: blogs);
      // final blogs = await blogRemoteDataSource.getAllBlogs();
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
