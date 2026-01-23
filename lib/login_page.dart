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

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
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
            onPressed: () async {
              final tokens = await login(
                "api/token/", 
                {
                  "username": usernameController.text,
                  "password": passwordController.text,
                }
              );
              if (tokens != null) {
                print("logged in successfully");
                appState.refreshToken = tokens[0];
                appState.accessToken = tokens[1];
              }
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

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
    super.dispose();
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
            onPressed: () async {
              final loginResponse = await login(
                "api/user/register/", 
                {
                  "username": usernameController.text,
                  "first_name": firstNameController.text,
                  "last_name": lastNameController.text,
                  "email": emailController.text,
                  "password": passwordController.text,                  
                },
              );
              if (loginResponse != null) {
                print("Created account!");
                appState.setLoginIndex(0);
              }
            },
            child: Text("Sign up")
          ),

          ElevatedButton(
            onPressed: () {
              appState.setLoginIndex(0);
            },
            child: Text("Already have an account?")
          )
        ],
      )
    );
  }
}

Future<List<String>?> login(String inputPath, Map<String, dynamic> inputBody) async {
  var response = await ApiService.post(
    inputPath,
    body: inputBody
  );  

  if (inputPath == "api/token/") {
    if (response.statusCode != 200) {
      AlertDialog(
        content: Text("Account not found"),
      );
      return null;
    } else {
      AlertDialog(
        content: Text("Logged in"),
      );
      return getTokens(response.body);
    }
  } else if (inputPath == "api/user/register/") {
    if (response.statusCode != 200) {
      AlertDialog(
        content: Text("Couldn't create account, Please try again or use different credentials"),
      );
      return null;
    } else {
      AlertDialog(
        content: Text("Created account"),
      );
      return ["Success"]; //i know i should use an enum for this function but ill do that later (probably)
    }
  } else {
    print("Unsupported path");
    return null;
  }
}

List<String> getTokens(String responseBody){
  String token = "";
  final tokens = <String>[];
  var bodies = responseBody.split(",");

  const disallowedChars = {'"', '{', '}', ':'};

  for (var body in bodies) {
    for (int i = body.indexOf(":"); i < body.length; i++) {
      if (!disallowedChars.contains(body[i])) {
        token += body[i];
      }
    }
    tokens.add(token);
    token = "";
  }
  return tokens;
}