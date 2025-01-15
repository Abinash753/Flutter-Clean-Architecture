import 'package:flutter_clean_architecture/core/common/entities/user.dart';
import 'package:flutter_clean_architecture/core/constants/constants.dart';
import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/network/connection_checker.dart';
import 'package:flutter_clean_architecture/features/auth/data/dataSources/auth_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/auth/data/models/user_model.dart';
import 'package:flutter_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
// import 'package:fpdart/src/either.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;
  const AuthRepositoryImpl(
    this.authRemoteDataSource,
    this.connectionChecker,
  );
  //
  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = authRemoteDataSource.curremtUserSession;
        if (session == null) {
          return left(
            Failure("User is not logged in "),
          );
        }
         return right(UserModel(id: session.user.id,
         email: session.user.email ?? "", 
         name: ""));
       
      }
      final user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(
          Failure("User is not logged in "),
        );
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword(
      {required String email, required String password}) async {
    return _getUser(
      () async => await authRemoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await authRemoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  //reusable function
  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(
          Failure(Constants.noConnectionErrorMessage),
        );
      }
      final user = await fn();
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
