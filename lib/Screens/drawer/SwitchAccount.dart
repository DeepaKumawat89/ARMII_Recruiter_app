import 'package:flutter/material.dart';

class SwitchAccount extends StatelessWidget {
  SwitchAccount({Key? key}) : super(key: key);

  // Dummy account data
  final List<Map<String, String>> accounts = [
    {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'avatar': 'J',
    },
    {
      'name': 'Jane Smith',
      'email': 'jane.smith@example.com',
      'avatar': 'J',
    },
    {
      'name': 'Alex Brown',
      'email': 'alex.brown@example.com',
      'avatar': 'A',
    },
  ];

  final int currentAccountIndex = 0; // Highlight the first account as current

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Switch Account', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                final isCurrent = index == currentAccountIndex;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isCurrent ? Colors.indigo.shade50 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: isCurrent
                        ? Border.all(color: Colors.indigo, width: 2)
                        : Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Text(
                        account['avatar']!,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                      ),
                    ),
                    title: Text(
                      account['name']!,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.indigo.shade900,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      account['email']!,
                      style: TextStyle(fontFamily: 'Inter', color: Colors.grey.shade700),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isCurrent)
                          IconButton(
                            icon: Icon(Icons.switch_account, color: Colors.indigo),
                            onPressed: () {
                              // Dummy switch action
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Switched to ${account['name']}', style: TextStyle(fontFamily: 'Inter'))),
                              );
                            },
                          ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.grey),
                          onPressed: () {
                            // Dummy remove action
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Removed ${account['name']}', style: TextStyle(fontFamily: 'Inter'))),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(Icons.add),
                label: Text('Add Account', style: TextStyle(fontFamily: 'Inter', fontSize: 18)),
                onPressed: () {
                  // Dummy add action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Add Account Clicked', style: TextStyle(fontFamily: 'Inter'))),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
