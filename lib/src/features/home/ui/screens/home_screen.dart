import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/src/features/auth/bloc/auth_bloc.dart';
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
        children: const [
          DashboardCard(
            title: 'Family',
            icon: Icons.group,
          ),
          DashboardCard(
            title: 'Health',
            icon: Icons.favorite,
          ),
          DashboardCard(
            title: 'Items',
            icon: Icons.shopping_cart,
          ),
          DashboardCard(
            title: 'Chat',
            icon: Icons.chat,
          ),
        ],
      ),
    );
  }
}
