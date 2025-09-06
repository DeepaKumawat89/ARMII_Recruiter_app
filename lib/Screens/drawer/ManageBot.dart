import 'package:flutter/material.dart';

class ManageBot extends StatefulWidget {
  const ManageBot({Key? key}) : super(key: key);

  @override
  State<ManageBot> createState() => _ManageBotState();
}

class _ManageBotState extends State<ManageBot> {
  bool botActive = true;
  bool autoReply = true;
  bool notifications = false;
  String botName = 'RecruiterBot';
  String botDescription = 'Helps you screen and interact with candidates.';
  String workingHours = '09:00 - 18:00';
  final List<String> activityLog = [
    'Sent welcome message to John Doe',
    'Screened candidate Jane Smith',
    'Scheduled interview for Alex Brown',
    'Sent reminder to candidate',
  ];
  String testInput = '';
  String testResponse = '';

  void sendTestMessage() {
    setState(() {
      testResponse = testInput.isEmpty
          ? ''
          : 'Bot: This is a dummy response to "$testInput".';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Bot', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bot Status
            Row(
              children: [
                Icon(
                  botActive ? Icons.check_circle : Icons.cancel,
                  color: botActive ? Colors.indigo : Colors.red,
                  size: 28,
                ),
                SizedBox(width: 8),
                Text(
                  botActive ? 'Bot is Active' : 'Bot is Inactive',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: botActive ? Colors.indigo : Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Switch(
                  value: botActive,
                  activeColor: Colors.indigo,
                  onChanged: (val) {
                    setState(() => botActive = val);
                  },
                ),
              ],
            ),
            Divider(height: 32),
            // Bot Profile
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.indigo,
                  child: Text(
                    botName[0],
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(botName,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            color: Colors.indigo.shade900,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 4),
                      Text(botDescription,
                          style: TextStyle(color: Colors.grey.shade700)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.indigo),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Edit Bot Profile Clicked')),
                    );
                  },
                ),
              ],
            ),
            Divider(height: 32),
            // Bot Settings
            Text('Bot Settings',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  color: Colors.grey.shade700,
                )),
            SwitchListTile(
              title: Text('Auto Reply', style: TextStyle(fontFamily: 'Inter', color: Colors.indigo.shade900)),
              value: autoReply,
              activeColor: Colors.indigo,
              onChanged: (val) => setState(() => autoReply = val),
            ),
            SwitchListTile(
              title: Text('Notifications', style: TextStyle(fontFamily: 'Inter', color: Colors.indigo.shade900)),
              value: notifications,
              activeColor: Colors.indigo,
              onChanged: (val) => setState(() => notifications = val),
            ),
            ListTile(
              title: Text('Working Hours', style: TextStyle(fontFamily: 'Inter', color: Colors.indigo.shade900)),
              subtitle: Text(workingHours, style: TextStyle(fontFamily: 'Inter', color: Colors.grey.shade700)),
              trailing: Icon(Icons.edit, color: Colors.indigo),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Edit Working Hours Clicked')),
                );
              },
            ),
            Divider(height: 32),
            // Activity Log
            Text('Activity Log',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  color: Colors.grey.shade700,
                )),
            Container(
              height: 120,
              child: ListView.builder(
                itemCount: activityLog.length,
                itemBuilder: (context, idx) => ListTile(
                  leading: Icon(Icons.bolt, color: Colors.indigo),
                  title: Text(activityLog[idx], style: TextStyle(fontFamily: 'Inter', color: Colors.grey.shade800)),
                ),
              ),
            ),
            Divider(height: 32),
            // Test Bot
            Text('Test the Bot',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  color: Colors.grey.shade700,
                )),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => setState(() => testInput = val),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: sendTestMessage,
                  child: Text('Send'),
                ),
              ],
            ),
            if (testResponse.isNotEmpty) ...[
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(testResponse, style: TextStyle(fontFamily: 'Inter', color: Colors.indigo.shade900)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
