import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/src/common/widgets/logout_button.dart';
import 'package:project/src/features/items/bloc/items_bloc.dart';
import 'package:project/src/features/items/data/models/item.dart';
import 'package:project/src/features/items/data/models/room.dart';
import 'package:project/src/features/items/ui/widgets/add_item_dialog.dart';
import 'package:project/src/features/items/ui/widgets/update_item_dialog.dart';

class ItemsScreen extends StatelessWidget {
  final Room room;

  const ItemsScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemsBloc()..add(ItemsFetchRequested(roomId: room.id)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(room.roomName),
          actions: const [LogoutButton()],
        ),
        body: BlocBuilder<ItemsBloc, ItemsState>(
          builder: (context, state) {
            if (state is ItemsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ItemsError) {
              return Center(child: Text(state.message));
            }
            if (state is ItemsLoadSuccess) {
              return ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return CheckboxListTile(
                    title: Text(item.itemName),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    value: item.status == ItemStatus.PURCHASED,
                    onChanged: (bool? value) {
                      if (value == true) {
                        showDialog(
                          context: context,
                          builder: (_) => UpdateItemDialog(
                            onUpdate: (cost) {
                              context.read<ItemsBloc>().add(
                                    ItemUpdateRequested(
                                      roomId: room.id,
                                      itemId: item.id,
                                      status: ItemStatus.PURCHASED,
                                      cost: cost,
                                    ),
                                  );
                            },
                          ),
                        );
                      } else {
                        context.read<ItemsBloc>().add(
                              ItemUpdateRequested(
                                roomId: room.id,
                                itemId: item.id,
                                status: ItemStatus.NEEDED,
                              ),
                            );
                      }
                    },
                  );
                },
              );
            }
            return const Center(child: Text('No items found.'));
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AddItemDialog(
                    onAdd: (itemName, quantity, cost) {
                      context.read<ItemsBloc>().add(
                            ItemAddRequested(
                              roomId: room.id,
                              itemName: itemName,
                              quantity: quantity,
                              cost: cost,
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
