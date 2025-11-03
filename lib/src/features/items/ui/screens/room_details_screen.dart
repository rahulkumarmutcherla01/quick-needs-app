import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/src/features/items/bloc/items_bloc.dart';
import 'package:project/src/features/items/data/repositories/items_repository.dart';
import 'package:project/src/features/rooms/data/models/room.dart';

class RoomDetailsScreen extends StatelessWidget {
  final Room room;

  const RoomDetailsScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(room.name),
      ),
      body: BlocProvider(
        create: (context) => ItemsBloc(
          itemsRepository: context.read<ItemsRepository>(),
        )..add(ItemsFetchRequested(roomId: room.id)),
        child: BlocBuilder<ItemsBloc, ItemsState>(
          builder: (context, state) {
            if (state is ItemsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ItemsError) {
              return Center(child: Text(state.message));
            }
            if (state is ItemsLoadSuccess) {
              return Column(
                children: [
                  _buildCreateItemForm(context),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return ListTile(
                          title: Text(item.name),
                          trailing: Checkbox(
                            value: item.isPurchased,
                            onChanged: (value) {
                              context.read<ItemsBloc>().add(
                                    ItemUpdateRequested(
                                      roomId: room.id,
                                      itemId: item.id,
                                      isPurchased: value,
                                    ),
                                  );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text('No items found.'));
          },
        ),
      ),
    );
  }

  Widget _buildCreateItemForm(BuildContext context) {
    final controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'New Item Name',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<ItemsBloc>().add(
                      ItemCreateRequested(
                        roomId: room.id,
                        name: controller.text,
                      ),
                    );
                controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
