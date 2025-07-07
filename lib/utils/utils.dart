class URLs{

  static final baseURL = "https://685a94379f6ef9611156f871.mockapi.io/api/v1";

  static final readUsers = "$baseURL/users";

  static final createUser = "$baseURL/users";

  static  readUserById(String id) => "$baseURL/users/$id";
  static  deleteUserById(String id) => "$baseURL/users/$id";
  static  updateUserById(String id) => "$baseURL/users/$id";


}