import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageGreetings extends StatefulWidget {
  const ManageGreetings({Key? key}) : super(key: key);

  @override
  State<ManageGreetings> createState() => _ManageGreetingsState();
}

class _ManageGreetingsState extends State<ManageGreetings> {
  List<String> _greetings = [];

  @override
  void initState() {
    super.initState();
    _loadGreetings();
  }

  Future<void> _loadGreetings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _greetings = prefs.getStringList('greetings') ?? [];
    });
  }

  Future<void> _saveGreetings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('greetings', _greetings);
  }

  void _addGreeting() async {
    String newGreeting = '';
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Greeting', style: GoogleFonts.playfairDisplay()),
        content: TextField(
          autofocus: true,
          onChanged: (value) => newGreeting = value,
          decoration: InputDecoration(hintText: 'Enter greeting'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newGreeting.trim().isNotEmpty) {
                Navigator.pop(context, newGreeting.trim());
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _greetings.add(result);
      });
      await _saveGreetings();
    }
  }

  void _editGreeting(int index) async {
    String editedGreeting = _greetings[index];
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Greeting', style: GoogleFonts.playfairDisplay()),
        content: TextField(
          autofocus: true,
          controller: TextEditingController(text: editedGreeting),
          onChanged: (value) => editedGreeting = value,
          decoration: InputDecoration(hintText: 'Edit greeting'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (editedGreeting.trim().isNotEmpty) {
                Navigator.pop(context, editedGreeting.trim());
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _greetings[index] = result;
      });
      await _saveGreetings();
    }
  }

  void _deleteGreeting(int index) async {
    setState(() {
      _greetings.removeAt(index);
    });
    await _saveGreetings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Greetings', style: GoogleFonts.playfairDisplay()),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add Greeting',
            onPressed: _addGreeting,
          ),
        ],
      ),
      body: _greetings.isEmpty
          ? Center(child: Text('No greetings yet.', style: GoogleFonts.playfairDisplay(fontSize: 18, color: Colors.grey)))
          : ListView.separated(
              itemCount: _greetings.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) => ListTile(
                title: Text(_greetings[index], style: GoogleFonts.playfairDisplay()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.indigo),
                      tooltip: 'Edit',
                      onPressed: () => _editGreeting(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () => _deleteGreeting(index),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
