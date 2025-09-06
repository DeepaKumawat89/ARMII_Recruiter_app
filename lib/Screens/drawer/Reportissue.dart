import 'package:flutter/material.dart';

class ReportIssue extends StatefulWidget {
  const ReportIssue({Key? key}) : super(key: key);

  @override
  State<ReportIssue> createState() => _ReportIssueState();
}

class _ReportIssueState extends State<ReportIssue> {
  final _formKey = GlobalKey<FormState>();
  String subject = '';
  String issueType = 'Bug';
  String description = '';
  String? attachedFile;
  final List<String> issueTypes = ['Bug', 'Feature Request', 'Feedback', 'Other'];
  final List<Map<String, String>> previousReports = [
    {'subject': 'App crash on login', 'status': 'Resolved'},
    {'subject': 'Feature: Dark mode', 'status': 'In Progress'},
    {'subject': 'Typo in dashboard', 'status': 'Open'},
  ];

  void submitReport() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Issue reported!')),
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
        title: Text('Report Issue', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Report a New Issue',
                style: TextStyle(
                  fontFamily: 'Inter',
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
                      labelStyle: TextStyle(fontFamily: 'Inter'),
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontFamily: 'Inter'),
                    validator: (val) => val == null || val.isEmpty ? 'Enter subject' : null,
                    onSaved: (val) => subject = val ?? '',
                  ),
                  SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: issueType,
                    items: issueTypes.map((t) => DropdownMenuItem(value: t, child: Text(t, style: TextStyle(fontFamily: 'Inter')))).toList(),
                    onChanged: (val) => setState(() => issueType = val ?? 'Bug'),
                    decoration: InputDecoration(
                      labelText: 'Issue Type',
                      labelStyle: TextStyle(fontFamily: 'Inter'),
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontFamily: 'Inter'),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(fontFamily: 'Inter'),
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontFamily: 'Inter'),
                    maxLines: 3,
                    validator: (val) => val == null || val.isEmpty ? 'Enter description' : null,
                    onSaved: (val) => description = val ?? '',
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
                        label: Text('Attach File', style: TextStyle(fontFamily: 'Inter')),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Attach File Clicked (demo only)')),
                          );
                        },
                      ),
                      if (attachedFile != null) ...[
                        SizedBox(width: 8),
                        Text(attachedFile!, style: TextStyle(fontFamily: 'Inter', color: Colors.grey.shade700)),
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
                      onPressed: submitReport,
                      child: Text('Submit', style: TextStyle(fontFamily: 'Inter', fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 32),
            Text('Previous Reports',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  color: Colors.grey.shade700,
                )),
            ...previousReports.map((rep) => ListTile(
                  leading: Icon(Icons.report, color: Colors.indigo),
                  title: Text(rep['subject']!, style: TextStyle(fontFamily: 'Inter', color: Colors.indigo.shade900)),
                  trailing: Chip(
                    label: Text(rep['status']!, style: TextStyle(fontFamily: 'Inter', color: Colors.white)),
                    backgroundColor: statusColor(rep['status']!),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
