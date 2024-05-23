import 'package:flutter/material.dart';
import 'dart:convert'; // Import dart:convert for jsonDecode
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: FirstScreen(),
  ));
}

String _errorMessage = "";

class FirstScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _occupationController = TextEditingController();
  final _bioController = TextEditingController();



  void _handleSubmit(BuildContext context) async {

    if (_formKey.currentState!.validate()) {
      // Get form values
      final name = _nameController.text;
      final email = _emailController.text;
      final occupation = _occupationController.text;
      final bio = _bioController.text;


      _nameController.text = '';
      _emailController.text = '';
      _occupationController.text = '';
      _bioController.text = '';
      _errorMessage = '';
      Future<dynamic> _updateUser(String id, Map<String, dynamic> userData) async {
        final response = await http.patch(
          Uri.parse('https://lionfish-app-qkntx.ondigitalocean.app/api/user/$id'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(userData),
        );
        if (response.statusCode == 200) {
          // Parse the JSON response (if any)
          final user = jsonDecode(response.body);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondScreen()),
          );
          return user;
        } else {
          // Handle error
          throw Exception('Failed to update user with id: $id');
        }
      }
      // final user = await UserApi.getUser("64118a3101d69493922202ba");
      // print(user);

      // I got the _id from postman.. or you can run this line
      // final users = await UserApi.getUsers();
      // print(users);
      final updatedUser = await _updateUser('64118a3101d69493922202ba', {
        "name": name,
        "email": email,
        "occupation": occupation,
        "bio": bio,
      });
      print(updatedUser);



    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('API PATCH TEST'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name.';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                TextFormField(
                  controller: _occupationController,
                  decoration: const InputDecoration(
                    labelText: 'Occupation',
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your occupation.';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    filled: true,
                  ),
                  maxLines: null, // Enable multiline input
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your bio.';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _handleSubmit(context),
                  child: const Text('Save Data'),
                ),
                const Spacer(),
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),

        ),

      ),
    );
  }

}

class UserApi {
  static Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse('https://lionfish-app-qkntx.ondigitalocean.app/api/users/'));
    if (response.statusCode == 200) {
      // Parse the JSON response into a list of users
      final users = jsonDecode(response.body) as List;
      return users;
    } else {
      // Handle error
      throw _errorMessage = 'Failed to load users';
    }
  }

  static Future<dynamic> getUser(String id) async {
    final response = await http.get(Uri.parse('https://lionfish-app-qkntx.ondigitalocean.app/api/user/$id'));
    if (response.statusCode == 200) {
      // Parse the JSON response into a user object
      final user = jsonDecode(response.body);
      return user;
    } else {
      // Handle error
      throw _errorMessage = 'Failed to load user with id: $id';
    }
  }
}


class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Success!"),
      ),
      body: Center(
        // padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text('Data has been posted to\nid 64118a3101d69493922202ba'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
            ]
      ),
      ),
    );
  }
}



