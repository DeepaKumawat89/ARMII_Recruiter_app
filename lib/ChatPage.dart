import 'package:flutter/material.dart';
import 'ChatDetailPage.dart';

class ChatPage extends StatelessWidget {
  final List<Map<String, String>> chats = [
    {
      'name': 'Alice',
      'lastMessage': 'See you soon!',
      'time': '09:30',
    },
    {
      'name': 'Bob',
      'lastMessage': 'Thanks for the update.',
      'time': '08:15',
    },
    {
      'name': 'Charlie',
      'lastMessage': 'Can we reschedule?',
      'time': 'Yesterday',
    },
    {
      'name': 'Diana',
      'lastMessage': 'Sent the documents.',
      'time': 'Yesterday',
    },
    {
      'name': 'Eve',
      'lastMessage': 'Good morning!',
      'time': 'Monday',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(child: Text(chat['name']![0])),
            title: Text(chat['name']!),
            subtitle: Text(chat['lastMessage']!),
            trailing: Text(chat['time']!, style: TextStyle(fontSize: 12, color: Colors.grey)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailPage(userName: chat['name']!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
