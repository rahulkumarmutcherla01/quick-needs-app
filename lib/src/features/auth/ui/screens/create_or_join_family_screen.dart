import 'package:flutter/material.dart';
import 'package:project/src/features/family/ui/screens/create_family_screen.dart';
import 'package:project/src/features/family/ui/screens/join_family_screen.dart';

class CreateOrJoinFamilyScreen extends StatelessWidget {
  const CreateOrJoinFamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to QuickNeeds!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'To get started, create a new family or join an existing one.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CreateFamilyScreen(),
                      ),
                    );
                  },
                  child: const Text('Create a Family'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const JoinFamilyScreen(),
                      ),
                    );
                  },
                  child: const Text('Join a Family'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
