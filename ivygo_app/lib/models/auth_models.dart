// Data models for authentication requests and responses.

class LoginRequest {
  const LoginRequest({required this.username, required this.password});

  final String username;
  final String password;

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

class LoginResponse {
  const LoginResponse(
      {required this.token,
      required this.accessToken,
      required this.refreshToken,
      this.user});

  final String token;
  final String accessToken;
  final String refreshToken;
  final UserModel? user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}

class UserModel {
  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.emailId,
    required this.mobileNumber,
    required this.username,
    required this.token,
    required this.restrictedUser,
    required this.userType,
    required this.businessName,
    required this.abn,
    required this.cognitoUserId,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String emailId;
  final String mobileNumber;
  final String username;
  final String token;
  final String restrictedUser;
  final String userType;
  final String businessName;
  final String abn;
  final String cognitoUserId;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      emailId: json['emailId'] as String,
      mobileNumber: json['mobileNumber'] as String,
      username: json['username'] as String,
      token: json['token'] as String,
      restrictedUser: json['restrictedUser'] as String,
      userType: json['userType'] as String,
      businessName: json['businessName'] as String,
      abn: json['abn'] as String,
      cognitoUserId: json['cognitoUserId'] as String,
    );
  }
}
