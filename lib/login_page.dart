import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'api.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    switch (appState.loginIndex) {
      case 0:
        return const Login();
      case 1:
        return const SignUp();
      default:
        throw UnimplementedError("Invalid login index");
    }
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<MyAppState>();

    return Center(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            setState(() => _loading = true);

                            final tokens = await login(
                              "api/token/",
                              {
                                "username": usernameController.text.trim(),
                                "password": passwordController.text,
                              },
                            );

                            setState(() => _loading = false);

                            if (tokens != null) {
                              appState.refreshToken = tokens[0];
                              appState.accessToken = tokens[1];
                              await appState.getFavorites();

                              _showDialog(context, "Login Successful");
                            } else {
                              _showDialog(context, "Invalid credentials");
                            }
                          },
                    child: _loading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Login"),
                  ),
                ),

                TextButton(
                  onPressed: () => appState.setLoginIndex(1),
                  child: const Text("Don't have an account? Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<MyAppState>();

    return Center(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 340,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                _field(firstNameController, "First name"),
                _field(lastNameController, "Last name"),
                _field(usernameController, "Username"),
                _field(emailController, "Email"),
                _field(passwordController, "Password", obscure: true),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            setState(() => _loading = true);

                            final success = await register(
                              {
                                "username": usernameController.text.trim(),
                                "first_name": firstNameController.text.trim(),
                                "last_name": lastNameController.text.trim(),
                                "email": emailController.text.trim(),
                                "password": passwordController.text,
                              },
                            );

                            setState(() => _loading = false);

                            if (success) {
                              _showDialog(context, "Account created");
                              appState.setLoginIndex(0);
                            } else {
                              _showDialog(context, "Sign up failed");
                            }
                          },
                    child: _loading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Create account"),
                  ),
                ),

                TextButton(
                  onPressed: () => appState.setLoginIndex(0),
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

Future<List<String>?> login(
  String path,
  Map<String, dynamic> body,
) async {
  final response = await ApiService.post(path, body: body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return [
      data["refresh"],
      data["access"],
    ];
  }

  return null;
}

Future<bool> register(Map<String, dynamic> body) async {
  final response = await ApiService.post(
    "api/user/register/",
    body: body,
  );

  return response.statusCode == 201 || response.statusCode == 200;
}

void _showDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Info"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        )
      ],
    ),
  );
}
