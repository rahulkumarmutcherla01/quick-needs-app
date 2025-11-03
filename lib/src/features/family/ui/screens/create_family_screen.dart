import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/src/features/family/bloc/family_bloc.dart';
import 'package:project/src/features/auth/ui/widgets/auth_button.dart';
import 'package:project/src/features/auth/ui/widgets/auth_input_field.dart';
import 'package:project/src/features/family/ui/screens/family_details_screen.dart';

class CreateFamilyScreen extends StatefulWidget {
  const CreateFamilyScreen({super.key});

  @override
  State<CreateFamilyScreen> createState() => _CreateFamilyScreenState();
}

class _CreateFamilyScreenState extends State<CreateFamilyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _familyNameController = TextEditingController();
  final _familySurnameController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Family'),
      ),
      body: BlocProvider(
        create: (context) => FamilyBloc(),
        child: BlocConsumer<FamilyBloc, FamilyState>(
          listener: (context, state) {
            if (state is FamilyCreationSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const FamilyDetailsScreen()),
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
                        'Tell us about your family',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 48),
                      AuthInputField(
                        controller: _familyNameController,
                        labelText: 'Family Name / Surname',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a family name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthInputField(
                        controller: _familySurnameController,
                        labelText: 'Family Name (Optional)',
                      ),
                      const SizedBox(height: 16),
                      AuthInputField(
                        controller: _cityController,
                        labelText: 'City (Optional)',
                      ),
                      const SizedBox(height: 32),
                      AuthButton(
                        isLoading: state is FamilyLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<FamilyBloc>().add(
                                  FamilyCreateRequested(
                                    familyName: _familyNameController.text,
                                    familySurname: _familySurnameController.text,
                                    city: _cityController.text,
                                  ),
                                );
                          }
                        },
                        text: 'Create Family',
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
