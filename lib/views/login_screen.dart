import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main_screen.dart';
import '../provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<User?> signInAnonymously() async {
  UserCredential userCredential = await _auth.signInAnonymously();
  return userCredential.user;
}

class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentAsyncValue = ref.watch(contentProviderSP);

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Sign in anonymously'),
          onPressed: () async {
            User? user = await signInAnonymously();
            if (user != null && contentAsyncValue is AsyncData) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
              );
            } else {
              // Show an error message
            }
          },
        ),
      ),
    );
  }
}
