import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/src/features/auth/bloc/auth_bloc.dart';
import 'package:project/src/features/family/ui/screens/family_details_screen.dart';
import 'package:project/src/features/home/ui/widgets/dashboard_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickNeeds Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: [
          DashboardCard(
            title: 'Family',
            icon: Icons.group,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FamilyDetailsScreen(),
                ),
              );
            },
          ),
          const DashboardCard(
            title: 'Health',
            icon: Icons.favorite,
          ),
          const DashboardCard(
            title: 'Items',
            icon: Icons.shopping_cart,
          ),
          const DashboardCard(
            title: 'Chat',
            icon: Icons.chat,
          ),
        ],
      ),
    );
  }
}
