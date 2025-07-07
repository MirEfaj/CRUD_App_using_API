import 'package:crud_app/controllers/userController.dart';
import 'package:crud_app/models/userModel.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserController usercontroller = UserController();
  bool isLoading = false;

  void _showSnackbar(String message) {if (!mounted) return;  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)), ); }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUsers();
  }


  Future<void> loadUsers() async {
    setState(() {
      isLoading = true;
    });
    try {
      await usercontroller.fetchUsers();
      if (!mounted) return;
    } catch (err) {
      _showSnackbar("Failed to load Users");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      bool status = await usercontroller.deleteUser(userId);
      if (!mounted) return;

      if (status) {
         await loadUsers();
         _showSnackbar("Successfully deleted User");
      } else {
        _showSnackbar("Failed to delete User");
      }
    } catch (err) {
      _showSnackbar("Internal server error");
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      final bool status = await usercontroller.createUser(user);
      if (!mounted) return;
      if (status) {
        _showSnackbar("User created successfully.");
        await loadUsers();
      } else {
        _showSnackbar("Failed to create user.");
      }
    } catch (err) {
      _showSnackbar("Error: ${err.toString()}");
    }
  }

  Future<void> upadatUser(UserModel user) async{
    try{
      bool status =await usercontroller.updateUser(user);
      if(!mounted) return ;
      if(status){
        await loadUsers();
        _showSnackbar("Successfully updated Users");
      }else{
        _showSnackbar("Failed to update Users");
      }
    }catch(err){
      _showSnackbar("Internal server error");
    }
  }

  Future<void> add_or_update_UserDialog({UserModel? selectedUser}) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController(text: selectedUser?.name);
    final TextEditingController emailController = TextEditingController(text: selectedUser?.email);
    final TextEditingController imageController = TextEditingController(text: selectedUser?.imageURL);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${selectedUser != null ? "Update" : "Create"} User"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Name"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email is required";
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: imageController,
                    decoration: InputDecoration(labelText: "Image URL (optional)"),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String name = nameController.text.trim();
                  String email = emailController.text.trim();
                  String imageURL = imageController.text.trim();

                  UserModel newUser = UserModel(
                    name: name,
                    email: email,
                    imageURL: imageURL.isNotEmpty ? imageURL : null,
                  );

                  if (selectedUser != null) {
                    newUser.id = selectedUser.id;
                  }
                  Navigator.pop(context);
                  selectedUser != null ? await upadatUser(newUser) : await createUser(newUser);
                }
              },

              child: Text(selectedUser != null ? "Update" : "Create"),
            ),
          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CRUD App"),foregroundColor: Colors.white, backgroundColor: Colors.blue,centerTitle: true,),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.blue.shade400, foregroundColor: Colors.white, onPressed: add_or_update_UserDialog, child: Icon(Icons.add),),

      body: isLoading
          ? Center(child: CircularProgressIndicator(),)
          : RefreshIndicator(
        onRefresh: loadUsers,
        child: ListView.builder(
            itemCount: usercontroller.users.length,
            itemBuilder: (context, index){
              UserModel user = usercontroller.users[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  color: Colors.blue.shade100,
                  child: ListTile(
                    leading: CircleAvatar(child: user.imageURL != null ? ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(50),
                        child: Image.network(user.imageURL!)) : Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_0BMwtQwTUjPjfj2nnbzTEOV1R-MEahGqXp4fb9ZW-QnG-TBGcZGs6CkNv8XL8f-txfM&usqp=CAU")),
                    title: Text(user.name ?? ""),
                    subtitle: Text(user.email ?? ""),
                    trailing: FittedBox(child: Row(
                      children: [
                        IconButton(onPressed: (){add_or_update_UserDialog(selectedUser: user);}, icon: Icon(Icons.edit)),
                        IconButton(onPressed: (){deleteUser(user.id!);}, icon: Icon(Icons.delete_outline, color: Colors.red,)),
                      ],
                    ),),
                  ),),
              );
            }),
      ),



    );
  }
}
