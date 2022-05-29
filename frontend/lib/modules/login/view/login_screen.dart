import 'package:flutter/material.dart';
import 'package:touragency_frontend/modules/login/view_model/login_view_model.dart';

class LoginView extends StatefulWidget {
  final LoginViewModel viewModel;

  const LoginView({required this.viewModel});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Touragency login"),
      ),
      body: Center(
        child: SizedBox(
          width: 360,
          height: 780,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (text) {
                  widget.viewModel.username.add(text);
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Login",
                    hintText: "Enter Login"),
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (text) {
                  widget.viewModel.password.add(text);
                },
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "Enter Password"),
              ),
              const SizedBox(height: 16),
              StreamBuilder(
                  stream: widget.viewModel.canLogin,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return ElevatedButton(
                        onPressed: snapshot.hasData && snapshot.data!
                            ? () {
                                widget.viewModel.didTapLogin();
                              }
                            : null,
                        child: const Text("Login"));
                  }),
              const SizedBox(height: 8),
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Hint"),
                              content: const Text(
                                  "Login - marina, password - q1w2e3"),
                            ));
                  },
                  child: const Text("Forgot password?",
                      style: TextStyle(fontSize: 12))),
              const SizedBox(height: 32),
              StreamBuilder(
                  stream: widget.viewModel.hasError,
                  initialData: false,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData && snapshot.data!) {
                      return const Text("Login or password is incorrect!",
                          style: TextStyle(color: Colors.redAccent));
                    } else {
                      return Container();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
