import 'package:flutter/material.dart';
import 'package:keep_learning/Data/models/session_model.dart';

class SessionWidget extends StatelessWidget {
  final Session session;
  final VoidCallback onTap; // Added callback for tapping the widget
  final VoidCallback onEdit; // Callback for editing the session
  final VoidCallback onDelete; // Callback for deleting the session

  const SessionWidget({
    super.key,
    required this.session,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(session.habitName),
        subtitle: Text("Duration: ${session.duration.inMinutes} minutes"),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit(); // Trigger the edit callback
            } else if (value == 'delete') {
              onDelete(); // Trigger the delete callback
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: const [
                    Icon(Icons.edit, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: const [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ];
          },
        ),
        onTap: onTap, // When tapping the widget, trigger the onTap callback
      ),
    );
  }
}
