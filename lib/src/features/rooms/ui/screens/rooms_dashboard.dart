import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/src/features/items/ui/screens/room_details_screen.dart';
import 'package/project/src/features/rooms/bloc/rooms_bloc.dart';
import 'package:project/src/features/rooms/data/repositories/rooms_repository.dart';

class RoomsDashboard extends StatelessWidget {
  final bool isAdmin;
  final String familyId;

  const RoomsDashboard({super.key, required this.isAdmin, required this.familyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
      ),
      body: BlocProvider(
        create: (context) => RoomsBloc(
          roomsRepository: context.read<RoomsRepository>(),
        )..add(RoomsFetchRequested(familyId: familyId)),
        child: BlocBuilder<RoomsBloc, RoomsState>(
          builder: (context, state) {
            if (state is RoomsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is RoomsError) {
              return Center(child: Text(state.message));
            }
            if (state is RoomsLoadSuccess) {
              return Column(
                children: [
                  if (isAdmin) _buildCreateRoomForm(context, familyId),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.rooms.length,
                      itemBuilder: (context, index) {
                        final room = state.rooms[index];
                        return ListTile(
                          title: Text(room.name),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RoomDetailsScreen(room: room),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text('No rooms found.'));
          },
        ),
      ),
    );
  }

  Widget _buildCreateRoomForm(BuildContext context, String familyId) {
    final controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'New Room Name',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<RoomsBloc>().add(RoomCreateRequested(
                      name: controller.text,
                      familyId: familyId,
                      icon: "default_icon", // Hardcoded for now
                    ));
                controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
