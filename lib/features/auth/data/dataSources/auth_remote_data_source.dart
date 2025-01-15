import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/features/auth/data/models/user_model.dart';
// import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get curremtUserSession;
  Future<UserModel> signUpWithEmailPassword(
      {required String name, required String email, required String password});
  //
  Future<UserModel> loginWithEmailPassword(
      {required String email, required String password});
  //to get the updated user auth info for session
  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient superbaseClient;
  AuthRemoteDataSourceImpl(this.superbaseClient);

  //auth user session
  @override
  Session? get curremtUserSession => superbaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await superbaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw const ServerException("User is null");
      }
      return UserModel.fromJson(response.user!.toJson()).copyWith(
        //my change
        id: response.user!.id,
        email: response.user!.email,
            name: response.user!.appMetadata['name']
            //
      );
    } on AuthException catch (e) {
         throw ServerException(e.message);
    }
     catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await superbaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          "name": name,
        },
      );
      if (response.user == null) {
        throw const ServerException("User is null!");
      }
      return UserModel.fromJson(response.user!.toJson()).copyWith(
        //my change
        id: response.user!.id,
        email: response.user!.email,
        name: response.user!.appMetadata['name']
        //

      );
    }  on AuthException catch (e) {
         throw ServerException(e.message);
    }
    catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (curremtUserSession != null) {
        final userData = await superbaseClient
            .from("profiles")
            .select()
            .eq("id", curremtUserSession!.user.id);
        return UserModel.fromJson(userData.first).copyWith(
          email: curremtUserSession!.user.email,
        );
      }
      return null;
    } catch (e) {
      throw ServerException(
        e.toString(),
      );
    }
  }
}
