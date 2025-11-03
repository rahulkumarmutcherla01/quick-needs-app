import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/src/features/auth/bloc/auth_bloc.dart';
import 'package:project/src/features/family/bloc/family_bloc.dart';
import 'package:project/src/features/auth/ui/widgets/auth_button.dart';
import 'package:project/src/features/auth/ui/widgets/auth_input_field.dart';
import 'package:project/src/features/family/data/repositories/family_repository.dart';

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
        create: (context) => FamilyBloc(
          familyRepository: context.read<FamilyRepository>(),
          authBloc: context.read<AuthBloc>(),
        ),
        child: BlocListener<FamilyBloc, FamilyState>(
          listener: (context, state) {
            if (state is FamilyError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<FamilyBloc, FamilyState>(
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
                          'Enter the family code',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 48),
                        AuthInputField(
                          controller: _familyCodeController,
                          labelText: 'Family Code',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a family code';
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
      ),
    );
  }
}
