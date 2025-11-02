import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/src/features/family/bloc/family_bloc.dart';
import 'package:project/src/features/auth/ui/widgets/auth_button.dart';
import 'package:project/src/features/auth/ui/widgets/auth_input_field.dart';
import 'package:project/src/features/items/ui/screens/rooms_dashboard.dart';

class JoinFamilyScreen extends StatefulWidget {
  const JoinFamilyScreen({super.key});

  @override
  State<JoinFamilyScreen> createState() => _JoinFamilyScreenState();
}

class _JoinFamilyScreenState extends State<JoinFamilyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _familyCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join a Family'),
      ),
      body: BlocProvider(
        create: (context) => FamilyBloc(),
        child: BlocConsumer<FamilyBloc, FamilyState>(
          listener: (context, state) {
            if (state is FamilyJoinApproved) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const RoomsDashboard()),
                (route) => false,
              );
            } else if (state is FamilyError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Enter the Family Code',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ask your family head for the 8-character code.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      AuthInputField(
                        controller: _familyCodeController,
                        labelText: 'Family Code',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a family code';
                          }
                          if (value.length != 8) {
                            return 'The code must be 8 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      AuthButton(
                        isLoading: state is FamilyLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<FamilyBloc>().add(
                                  FamilyJoinRequested(
                                    familyCode: _familyCodeController.text,
                                  ),
                                );
                          }
                        },
                        text: 'Join Family',
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
