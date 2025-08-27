import 'package:flutter/material.dart';
import 'SubScreen/ChatDetailPage.dart';

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
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        itemCount: chats.length,
        separatorBuilder: (context, index) => Divider(height: 1, indent: 72, endIndent: 12),
        itemBuilder: (context, index) {
          final chat = chats[index];
          final bool hasUnread = index == 0; // Demo: first chat has unread
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              leading: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue[300]!, Colors.blue[700]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 26,
                  child: Text(
                    chat['name']![0],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      chat['name']!,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (hasUnread)
                    Container(
                      margin: EdgeInsets.only(left: 6),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  chat['lastMessage']!,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: Text(
                chat['time']!,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatDetailPage(userName: chat['name']!),
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              tileColor: Colors.white,
              hoverColor: Colors.blue[50],
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
