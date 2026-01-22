import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'api.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    Widget loginPage;

    final appState = context.watch<MyAppState>();

    switch (appState.loginIndex){
      case 0:
        loginPage = Login();
      case 1:
        loginPage = SignUp();
      default:
        throw UnimplementedError("Index not possible for login widget");
    }
    
    return loginPage;
  }
}

class Login extends StatelessWidget {
  Login({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }

  Widget build(BuildContext context) {
    final appState = context.read<MyAppState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Login"),
          SizedBox(height: 20),
          
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Username"
            ),
            controller: usernameController,
          ),

          SizedBox(height: 10),

          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Password",
            ),
            controller: passwordController,
          ),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              login(
                "api/token/", 
                {
                  "username": usernameController.text,
                  "password": passwordController.text,
                }
              );
            },
            child: Text("Login")
          ),

          ElevatedButton(
            onPressed: () {
              appState.setLoginIndex(1);
            },
            child: Text("Don't ave an account?")
          )
        ],
      )
    );
  }
}

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
  }

  Widget build(BuildContext context) {
    final appState = context.read<MyAppState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Sign Up"),
          SizedBox(height: 20),
          
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "First Name"
            ),
            controller: firstNameController,
          ),


          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Last Name"
            ),
            controller: lastNameController,
          ),

          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Username"
            ),
            controller: usernameController,
          ),

          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Email"
            ),
            controller: emailController,
          ),

          SizedBox(height: 10),

          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Password",
            ),
            controller: passwordController,
          ),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              login(
                "api/user/register/", 
                {
                  "username": usernameController.text,
                  "first_name": firstNameController.text,
                  "last_name": lastNameController.text,
                  "email": emailController.text,
                  "password": passwordController.text,                  
                }
              );
            },
            child: Text("Sign up")
          ),

          ElevatedButton(
            onPressed: () {
              appState.setLoginIndex(1);
            },
            child: Text("Already have an account?")
          )
        ],
      )
    );
  }
}

Future<void> login(String inputPath, Map<String, dynamic> inputBody) async {
  var response = await ApiService.post(
    inputPath,
    body: inputBody
  );  
  print(response.statusCode);
  if (response.statusCode != 400) {
    AlertDialog(
      content: Text("Account not found"),
    );
  } else {
    AlertDialog(
      content: Text("Logged in"),
    );
  }
}