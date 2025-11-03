import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/src/features/auth/bloc/auth_bloc.dart';
import 'package:project/src/features/family/bloc/family_details_bloc.dart';
import 'package:project/src/features/items/ui/screens/rooms_dashboard.dart';

class FamilyDetailsScreen extends StatelessWidget {
  const FamilyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Hub'),
      ),
      body: BlocProvider(
        create: (context) => FamilyDetailsBloc()..add(FamilyDetailsFetchRequested()),
        child: BlocBuilder<FamilyDetailsBloc, FamilyDetailsState>(
          builder: (context, state) {
            if (state is FamilyDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FamilyDetailsError) {
              return Center(child: Text(state.message));
            }
            if (state is FamilyDetailsLoadSuccess) {
              final family = state.family;
              final authState = context.read<AuthBloc>().state;
              final bool amIAdmin = authState is AuthAuthenticated && authState.user.id == family.createdByUserId;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      family.familyName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Family Code: ${family.familyCode}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {
                            // TODO: Implement share functionality
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Members',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: family.members?.length ?? 0,
                        itemBuilder: (context, index) {
                          final member = family.members![index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(member.firstName[0]),
                            ),
                            title: Text('${member.firstName} ${member.lastName ?? ''}'),
                            subtitle: Text(member.email),
                            trailing: amIAdmin && member.id != (authState as AuthAuthenticated).user.id
                                ? IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      context.read<FamilyDetailsBloc>().add(FamilyMemberRemoveRequested(userId: member.id));
                                    },
                                  )
                                : null,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Rooms',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RoomsDashboard(isAdmin: amIAdmin),
                          ),
                        );
                      },
                      child: const Text('View Rooms'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('No family details found.'));
          },
        ),
      ),
    );
  }
}
