import 'package:flutter/material.dart';

class AddRoomDialog extends StatefulWidget {
  final Function(String roomName, String roomIcon) onAdd;

  const AddRoomDialog({super.key, required this.onAdd});

  @override
  State<AddRoomDialog> createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends State<AddRoomDialog> {
  final _formKey = GlobalKey<FormState>();
  final _roomNameController = TextEditingController();
  String _selectedIcon = 'other';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a new room'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _roomNameController,
              decoration: const InputDecoration(labelText: 'Room Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a room name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // TODO: Replace with a more sophisticated icon picker
            DropdownButtonFormField<String>(
              value: _selectedIcon,
              items: const [
                DropdownMenuItem(value: 'kitchen', child: Text('Kitchen')),
                DropdownMenuItem(value: 'bedroom', child: Text('Bedroom')),
                DropdownMenuItem(value: 'bathroom', child: Text('Bathroom')),
                DropdownMenuItem(value: 'living_room', child: Text('Living Room')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedIcon = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onAdd(_roomNameController.text, _selectedIcon);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
