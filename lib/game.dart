import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class PasswordGamePage extends StatefulWidget {
  const PasswordGamePage({super.key});

  @override
  State<PasswordGamePage> createState() => _PasswordGamePageState();
}

class _PasswordGamePageState extends State<PasswordGamePage> {
  final TextEditingController _controller = TextEditingController();

  final String correctAnswer = "a2f27dee5856e6557ae4b9fa2716d241d49dc67b1853574eee3b64840bd8ccb4";
  String resultMessage = "";

  String hashInput(String input) {
    final bytes = utf8.encode(input.trim().toLowerCase());
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void checkAnswer() {
    if (hashInput(_controller.text) == correctAnswer) {
      setState(() {
        resultMessage = "🎉 You win the prize 💰";
      });
    } else {
      setState(() {
        resultMessage = "❌ Wrong answer. Try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Developer Challenge")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "What's your answer?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter answer",
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: checkAnswer,
                child: const Text("Submit"),
              ),

              const SizedBox(height: 20),

              Text(
                resultMessage,
                style: const TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
}