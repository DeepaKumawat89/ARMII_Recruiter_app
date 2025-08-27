import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestHelp extends StatefulWidget {
  const RequestHelp({Key? key}) : super(key: key);

  @override
  State<RequestHelp> createState() => _RequestHelpState();
}

class _RequestHelpState extends State<RequestHelp> {
  final _formKey = GlobalKey<FormState>();
  String subject = '';
  String topic = 'Account';
  String message = '';
  String? attachedFile;
  final List<String> topics = ['Account', 'Payment', 'Technical', 'Other'];
  final List<Map<String, String>> faqs = [
    {'q': 'How do I reset my password?', 'a': 'Go to Profile > Change Password.'},
    {'q': 'How to contact support?', 'a': 'Use the form or email support@armii.com.'},
    {'q': 'How to update my profile?', 'a': 'Go to Profile > Edit.'},
  ];
  final List<Map<String, String>> previousRequests = [
    {'subject': 'Login Issue', 'status': 'Resolved'},
    {'subject': 'Payment not processed', 'status': 'In Progress'},
    {'subject': 'App crash', 'status': 'Open'},
  ];

  void submitRequest() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Help request submitted!')),
      );
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case 'Resolved':
        return Colors.indigo;
      case 'In Progress':
        return Colors.orange;
      case 'Open':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Help', style: GoogleFonts.playfairDisplay()),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Help Request Form
            Text('Submit a Help Request',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                )),
            SizedBox(height: 8),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Enter subject' : null,
                    onSaved: (val) => subject = val ?? '',
                  ),
                  SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: topic,
                    items: topics.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) => setState(() => topic = val ?? 'Account'),
                    decoration: InputDecoration(
                      labelText: 'Topic',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (val) => val == null || val.isEmpty ? 'Enter message' : null,
                    onSaved: (val) => message = val ?? '',
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        icon: Icon(Icons.attach_file),
                        label: Text('Attach File'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Attach File Clicked (demo only)')),
                          );
                        },
                      ),
                      if (attachedFile != null) ...[
                        SizedBox(width: 8),
                        Text(attachedFile!, style: TextStyle(color: Colors.grey.shade700)),
                      ]
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: submitRequest,
                      child: Text('Submit', style: GoogleFonts.playfairDisplay(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 32),
            // Contact Options
            Text('Contact Options',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                )),
            ListTile(
              leading: Icon(Icons.email, color: Colors.indigo),
              title: Text('support@armii.com', style: TextStyle(color: Colors.indigo.shade900)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.indigo),
              title: Text('+91 98765 43210', style: TextStyle(color: Colors.indigo.shade900)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.chat, color: Colors.indigo),
              title: Text('Live Chat', style: TextStyle(color: Colors.indigo.shade900)),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Live Chat Clicked (demo only)')),
                );
              },
            ),
            Divider(height: 32),
            // FAQ Section
            Text('Frequently Asked Questions',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                )),
            ...faqs.map((faq) => ExpansionTile(
                  title: Text(faq['q']!, style: TextStyle(color: Colors.indigo.shade900)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(faq['a']!, style: TextStyle(color: Colors.grey.shade800)),
                    ),
                  ],
                )),
            Divider(height: 32),
            // Previous Requests
            Text('Previous Requests',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                )),
            ...previousRequests.map((req) => ListTile(
                  leading: Icon(Icons.help, color: Colors.indigo),
                  title: Text(req['subject']!, style: TextStyle(color: Colors.indigo.shade900)),
                  trailing: Chip(
                    label: Text(req['status']!, style: TextStyle(color: Colors.white)),
                    backgroundColor: statusColor(req['status']!),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
