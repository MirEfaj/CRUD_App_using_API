import 'dart:convert';

import 'package:crud_app/models/userModel.dart';
import 'package:http/http.dart' as http;

import '../utils/utils.dart';

class UserController{
final List<UserModel> users = [];

Future<void> fetchUsers() async {
  try{
    final response =await http.get(Uri.parse(URLs.readUsers));
    if(response.statusCode == 200){
      final usersJSON = jsonDecode(response.body);
      users.clear();
      usersJSON.forEach((usersJson) => users.add(UserModel.fromJson(usersJson)));
    }else{
      throw Exception("Failed to load users");
    }
  }catch(err){
    throw Exception("internal server error");
  }
}


Future<bool> deleteUser(String userId) async{
  try{
    final response =await http.delete(Uri.parse(URLs.updateUserById(userId)));
    if(response.statusCode == 200){
      await fetchUsers();
      return true;
    }else{
      throw  Exception("Failed to delete");
    }
  }catch(err){
    throw Exception("internal server error");
  }
}


Future<bool> createUser(UserModel user) async {
  try{
    final response =await http.post(Uri.parse(URLs.createUser),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),);
    if(response.statusCode == 201){
      await fetchUsers();
      return true;
    }else{
      throw Exception("Failed to create user");
    }
  }catch(err){
    throw Exception("Internal Server error");
  }
}

Future<bool> updateUser(UserModel user) async {
  try{
    final response =await http.put(Uri.parse(URLs.updateUserById(user.id!)),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),);
    if(response.statusCode == 200){
      await fetchUsers();
      return true;
    }else{
      throw Exception("Failed to update user");
    }
  }catch(err){
    print(err);
    rethrow;

    // throw Exception("Internal Server error");
  }
}




}