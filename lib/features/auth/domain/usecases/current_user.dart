import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/usecase/usecase.dart';
import 'package:flutter_clean_architecture/core/common/entities/user.dart';
import 'package:flutter_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
// import 'package:fpdart/src/either.dart';

class CurrentUser implements Usecase<User, NoParams> {
  final AuthRepository authRepository;
  const CurrentUser(this.authRepository);
  @override
  Future<Either<Failure, User>> call(NoParams noParams) async {
    return await authRepository.currentUser();
  }
}
