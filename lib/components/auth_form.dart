import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                shadowColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: const Text(
                'Entrar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                shadowColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: const Text(
                'Criar uma nova conta?',
                style: TextStyle(color: Colors.blue),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
