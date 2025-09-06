import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class InternshipProvider with ChangeNotifier {
  bool _isPaid = false;
  String _location = '';
  String _role = '';
  String _educationLevel = '';
  String _payFrom = '';
  String _payTo = '';
  String _requirements = '';
  String _extraSkills = '';

  bool get isPaid => _isPaid;
  String get location => _location;
  String get role => _role;
  String get educationLevel => _educationLevel;
  String get payFrom => _payFrom;
  String get payTo => _payTo;
  String get requirements => _requirements;
  String get extraSkills => _extraSkills;

  // Clear all fields
  void clearFields() {
    _isPaid = false;
    _location = '';
    _role = '';
    _educationLevel = '';
    _payFrom = '';
    _payTo = '';
    _requirements = '';
    _extraSkills = '';
    notifyListeners();
  }

  // Validation method
  String? validateFields() {
    if (_location.trim().isEmpty) {
      return 'Location is required';
    }
    if (_role.trim().isEmpty) {
      return 'Role name is required';
    }
    if (_educationLevel.trim().isEmpty) {
      return 'Education level is required';
    }
    if (_isPaid) {
      if (_payFrom.trim().isEmpty || _payTo.trim().isEmpty) {
        return 'Pay scale is required for paid internships';
      }
      // Validate if pay values are valid numbers
      try {
        final payFromValue = double.parse(_payFrom);
        final payToValue = double.parse(_payTo);
        if (payFromValue > payToValue) {
          return 'Minimum pay cannot be greater than maximum pay';
        }
      } catch (e) {
        return 'Please enter valid pay values';
      }
    }
    if (_requirements.trim().isEmpty) {
      return 'Requirements are required';
    }
    if (_extraSkills.trim().isEmpty) {
      return 'Extra skills are required';
    }
    return null;
  }

  void setIsPaid(bool value) {
    _isPaid = value;
    notifyListeners();
  }

  void setLocation(String value) {
    _location = value;
    notifyListeners();
  }

  void setRole(String value) {
    _role = value;
    notifyListeners();
  }

  void setEducationLevel(String value) {
    _educationLevel = value;
    notifyListeners();
  }

  void setPayFrom(String value) {
    _payFrom = value;
    notifyListeners();
  }

  void setPayTo(String value) {
    _payTo = value;
    notifyListeners();
  }

  void setRequirements(String value) {
    _requirements = value;
    notifyListeners();
  }

  void setExtraSkills(String value) {
    _extraSkills = value;
    notifyListeners();
  }

  Future<bool> saveInternship() async {
    try {
      final database = await _initDatabase();
      await database.insert('internships', {
        'location': _location,
        'role': _role,
        'education_level': _educationLevel,
        'pay_from': _isPaid ? _payFrom : null,
        'pay_to': _isPaid ? _payTo : null,
        'extra_requirements': _requirements,
        'extra_skills': _extraSkills,
        'is_paid': _isPaid ? 1 : 0, // Store as integer in SQLite
      });
      return true;
    } catch (e) {
      print('Error saving internship: $e');
      return false;
    }
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'internships.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE internships (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            location TEXT,
            role TEXT,
            education_level TEXT,
            pay_from TEXT,
            pay_to TEXT,
            extra_requirements TEXT,
            extra_skills TEXT,
            is_paid INTEGER
          )
        ''');
      },
    );
  }
}
