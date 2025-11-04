import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/src/features/items/bloc/items_bloc.dart';
import 'package:project/src/features/items/data/models/item.dart';
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
                          subtitle: Text('Quantity: ${item.quantity}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: item.status == ItemStatus.PURCHASED,
                                onChanged: (value) {
                                  context.read<ItemsBloc>().add(
                                        ItemUpdateRequested(
                                          roomId: room.id,
                                          itemId: item.id,
                                          status: value!
                                              ? ItemStatus.PURCHASED
                                              : ItemStatus.PENDING,
                                        ),
                                      );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  context.read<ItemsBloc>().add(
                                        ItemDeleteRequested(
                                          roomId: room.id,
                                          itemId: item.id,
                                        ),
                                      );
                                },
                              ),
                            ],
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
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'New Item Name',
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 80,
            child: TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Qty',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  quantityController.text.isNotEmpty) {
                context.read<ItemsBloc>().add(
                      ItemCreateRequested(
                        roomId: room.id,
                        name: nameController.text,
                        quantity: int.parse(quantityController.text),
                      ),
                    );
                nameController.clear();
                quantityController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
