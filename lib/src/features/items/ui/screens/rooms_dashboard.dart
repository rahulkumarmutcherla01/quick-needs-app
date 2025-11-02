import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/src/features/auth/bloc/auth_bloc.dart';
import 'package:project/src/features/items/bloc/rooms_bloc.dart';
import 'package:project/src/features/items/ui/screens/items_screen.dart';
import 'package:project/src/features/items/ui/widgets/add_room_dialog.dart';

class RoomsDashboard extends StatelessWidget {
  const RoomsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomsBloc()..add(RoomsFetchRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rooms'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            ),
          ],
        ),
        body: BlocBuilder<RoomsBloc, RoomsState>(
          builder: (context, state) {
            if (state is RoomsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is RoomsError) {
              return Center(child: Text(state.message));
            }
            if (state is RoomsLoadSuccess) {
              return ListView.builder(
                itemCount: state.rooms.length,
                itemBuilder: (context, index) {
                  final room = state.rooms[index];
                  return ListTile(
                    leading: const Icon(Icons.room),
                    title: Text(room.roomName),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ItemsScreen(room: room),
                        ),
                      );
                    },
                  );
                },
              );
            }
            return const Center(child: Text('No rooms found.'));
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AddRoomDialog(
                    onAdd: (roomName, roomIcon) {
                      context.read<RoomsBloc>().add(
                            RoomAddRequested(
                              roomName: roomName,
                              roomIcon: roomIcon,
                            ),
                          );
                    },
                  ),
                );
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}
