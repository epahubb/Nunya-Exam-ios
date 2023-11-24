import 'package:firebase_auth/firebase_auth.dart';
import 'package:nunyaexam/features/auth/auhtException.dart';
import 'package:nunyaexam/features/auth/authLocalDataSource.dart';
import 'package:nunyaexam/features/auth/authRemoteDataSource.dart';
import 'package:nunyaexam/features/auth/cubits/authCubit.dart' as CubitAuth;

class AuthRepository {
  static final AuthRepository _authRepository = AuthRepository._internal();
  late AuthLocalDataSource _authLocalDataSource;
  late AuthRemoteDataSource _authRemoteDataSource;

  factory AuthRepository() {
    _authRepository._authLocalDataSource = AuthLocalDataSource();
    _authRepository._authRemoteDataSource = AuthRemoteDataSource();
    return _authRepository;
  }

  AuthRepository._internal();

  //to get auth detials stored in hive box
  Map<String, dynamic> getLocalAuthDetails() {
    return {
      "isLogin": AuthLocalDataSource.checkIsAuth(),
      "jwtToken": AuthLocalDataSource.getJwtToken(),
      "firebaseId": AuthLocalDataSource.getUserFirebaseId(),
      "authProvider":
          getAuthProviderFromString(AuthLocalDataSource.getAuthType()),
    };
  }

  void setLocalAuthDetails(
      {String? jwtToken,
      String? firebaseId,
      String? authType,
      bool? authStatus,
      bool? isNewUser}) {
    _authLocalDataSource.changeAuthStatus(authStatus);

    _authLocalDataSource.setUserFirebaseId(firebaseId);
    _authLocalDataSource.setAuthType(authType);
  }

  //First we signin user with given provider then add user details
  Future<Map<String, dynamic>> signInUser(
    CubitAuth.AuthProvider authProvider, {
    required String email,
    required String password,
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final result = await _authRemoteDataSource.signInUser(
        authProvider,
        email: email,
        password: password,
        smsCode: smsCode,
        verificationId: verificationId,
      );
      print("printing result");
      print(result);
      final user = result['user'] as User;
      bool isNewUser = result['isNewUser'] as bool;

      if (authProvider == CubitAuth.AuthProvider.email) {
        //check if user exist or not
        final isUserExist = await _authRemoteDataSource.isUserExist(user.uid);
        //if user does not exist add in database
        if (!isUserExist) {
          print("creating new user");
          isNewUser = true;
          final registeredUser = await _authRemoteDataSource.addUser(
            email: user.email ?? "",
            firebaseId: user.uid,
            mobile: user.phoneNumber ?? "",
            name: user.displayName ?? "",
            type: getAuthTypeString(authProvider),
            profile: user.photoURL ?? "",
          );
          print("Registered user");
          print(registeredUser);
          print("JWT TOKEN is : ${registeredUser['api_token']}");

          // store jwt token
          // await AuthLocalDataSource.setJwtToken(
          //     registeredUser['api_token'].toString());
          await AuthLocalDataSource.setJwtToken(
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJc3N1ZXIgKGlzcykiOiJJc3N1ZXIiLCJJc3N1ZWQgQXQgKGlhdCkiOiIyMDIzLTExLTAxVDEyOjM5OjAxLjAzOFoiLCJFeHBpcmF0aW9uIFRpbWUgKGV4cCkiOiIyMDIzLTExLTAxVDEzOjM5OjAxLjAzOFoiLCJTdWJqZWN0IChzdWIpIjoiU3ViamVjdCIsIlVzZXJuYW1lIChhdWQpIjoiSmF2YUd1aWRlcyIsIlJvbGUiOiJBRE1JTiJ9.TMo3Aqqf9OUepf_7C1qbCLH7FHGbjtKdc9dOnhY_bdY");
        } else {
          //get jwt token of user
          final jwtToken = await _authRemoteDataSource.getJWTTokenOfUser(
              firebaseId: user.uid, type: getAuthTypeString(authProvider));

          //store jwt token
          await AuthLocalDataSource.setJwtToken(jwtToken);

          await _authRemoteDataSource.updateFcmId(
              firebaseId: user.uid, userLoggingOut: false);
        }
      } else {
        if (isNewUser) {
          //
          final registeredUser = await _authRemoteDataSource.addUser(
            email: user.email ?? "",
            firebaseId: user.uid,
            mobile: user.phoneNumber ?? "",
            name: user.displayName ?? "",
            type: getAuthTypeString(authProvider),
            profile: user.photoURL ?? "",
          );

          //store jwt token
          print("JWT TOKEN is : ${registeredUser['api_token']}");
          await AuthLocalDataSource.setJwtToken(registeredUser['api_token']);
        } else {
          //get jwt token of user
          final jwtToken = await _authRemoteDataSource.getJWTTokenOfUser(
              firebaseId: user.uid, type: getAuthTypeString(authProvider));

          print("Jwt token $jwtToken");
          //store jwt token
          await AuthLocalDataSource.setJwtToken(jwtToken);
          //
          await _authRemoteDataSource.updateFcmId(
              firebaseId: user.uid, userLoggingOut: false);
        }
      }
      return {
        "user": user,
        "isNewUser": isNewUser,
      };
    } catch (e) {
      print(e.toString());
      signOut(authProvider);
      throw AuthException(errorMessageCode: e.toString());
    }
  }

  //to signUp user
  Future<void> signUpUser(String email, String password) async {
    try {
      await _authRemoteDataSource.signUpUser(email, password);
    } catch (e) {
      signOut(CubitAuth.AuthProvider.email);
      
      throw AuthException(errorMessageCode: e.toString());
    }
  }

  Future<void> signOut(CubitAuth.AuthProvider? authProvider) async {
    //remove fcm token when user logout
    try {
      _authRemoteDataSource.updateFcmId(
          firebaseId: AuthLocalDataSource.getUserFirebaseId(),
          userLoggingOut: true);
      _authRemoteDataSource.signOut(authProvider);
      setLocalAuthDetails(
          authStatus: false,
          authType: "",
          jwtToken: "",
          firebaseId: "",
          isNewUser: false);
    } catch (e) {}
  }

  String getAuthTypeString(CubitAuth.AuthProvider provider) {
    String authType;
    if (provider == CubitAuth.AuthProvider.fb) {
      authType = "fb";
    } else if (provider == CubitAuth.AuthProvider.gmail) {
      authType = "gmail";
    } else if (provider == CubitAuth.AuthProvider.mobile) {
      authType = "mobile";
    } else if (provider == CubitAuth.AuthProvider.apple) {
      authType = "apple";
    } else {
      authType = "email";
    }
    return authType;
  }

  //to add user's data to database. This will be in use when authenticating using phoneNumber
  Future<Map<String, dynamic>> addUserData(
      {String? firebaseId,
      String? type,
      String? name,
      String? profile,
      String? mobile,
      String? email,
      String? referCode,
      String? friendCode}) async {
    try {
      final result = await _authRemoteDataSource.addUser(
          email: email,
          firebaseId: firebaseId,
          friendCode: friendCode,
          mobile: mobile,
          name: name,
          profile: profile,
          referCode: referCode,
          type: type);

      //Update jwt token
      await AuthLocalDataSource.setJwtToken(result['api_token'].toString());

      return Map.from(result); //
    } catch (e) {
      signOut(CubitAuth.AuthProvider.mobile);
      throw AuthException(errorMessageCode: e.toString());
    }
  }

  CubitAuth.AuthProvider getAuthProviderFromString(String? value) {
    CubitAuth.AuthProvider authProvider;
    if (value == "fb") {
      authProvider = CubitAuth.AuthProvider.fb;
    } else if (value == "gmail") {
      authProvider = CubitAuth.AuthProvider.gmail;
    } else if (value == "mobile") {
      authProvider = CubitAuth.AuthProvider.mobile;
    } else if (value == "apple") {
      authProvider = CubitAuth.AuthProvider.apple;
    } else {
      authProvider = CubitAuth.AuthProvider.email;
    }
    return authProvider;
  }
}
