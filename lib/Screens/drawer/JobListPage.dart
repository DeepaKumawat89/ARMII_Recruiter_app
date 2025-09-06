import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../widget/customroundedappbar.dart';

class JobListPage extends StatefulWidget {
  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _jobs = [];
  List<Map<String, dynamic>> _internships = [];
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _fetchJobs(),
      _fetchInternships(),
    ]);
    setState(() => _isLoading = false);
  }

  Future<void> _fetchJobs() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'jobs.db');
      final db = await openDatabase(path);
      // Only fetch jobs where display_this is 1 (true)
      final jobs = await db.query(
        'jobs',
        orderBy: 'id DESC',
        where: 'display_this = ?',
        whereArgs: [1],
      );
      setState(() {
        _jobs = jobs;
      });
    } catch (e) {
      print('Error fetching jobs: $e');
    }
  }

  Future<void> _fetchInternships() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'internships.db');
      final db = await openDatabase(path);
      final internships = await db.query('internships', orderBy: 'id DESC');
      setState(() {
        _internships = internships;
      });
    } catch (e) {
      print('Error fetching internships: $e');
    }
  }

  Widget _buildListItem(Map<String, dynamic> item, bool isJob) {
    final primaryColor = Color(0xFF3949AB);
    final cardColor = isJob ? Colors.white : Color(0xFFF5F7FA);
    final tagColor = isJob ? primaryColor : Colors.green;

    // Convert SQLite integer to bool for isPaid
    final isPaid = item['is_paid'] == 1;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item['role'] ?? 'No Role',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: tagColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isJob ? 'Job' : (isPaid ? 'Paid Internship' : 'Unpaid Internship'),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: tagColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.grey[600], size: 18),
                  SizedBox(width: 4),
                  Text(
                    item['location'] ?? 'No Location',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.school_outlined, color: Colors.grey[600], size: 18),
                  SizedBox(width: 4),
                  Text(
                    item['education_level'] ?? 'No Education Level',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (isJob || (item['pay_from'] != null && item['pay_to'] != null)) ...[
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.currency_rupee, color: Colors.grey[600], size: 18),
                    SizedBox(width: 4),
                    Text(
                      '${item['pay_from'] ?? ''} - ${item['pay_to'] ?? ''}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 12),
              Text(
                'Requirements:',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                item['extra_requirements'] ?? 'No Requirements',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.grey[800],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Text(
                'Extra Skills:',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                item['extra_skills'] ?? 'No Extra Skills',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.grey[800],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF3949AB);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: customRoundedAppBar(context, 'Posted Jobs & Internships'),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: primaryColor,
              labelStyle: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                Tab(text: 'Jobs (${_jobs.length})'),
                Tab(text: 'Internships (${_internships.length})'),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _jobs.isEmpty
                          ? Center(
                              child: Text(
                                'No jobs posted yet',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _fetchData,
                              child: ListView.builder(
                                itemCount: _jobs.length,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                itemBuilder: (context, index) => _buildListItem(_jobs[index], true),
                              ),
                            ),
                      _internships.isEmpty
                          ? Center(
                              child: Text(
                                'No internships posted yet',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _fetchData,
                              child: ListView.builder(
                                itemCount: _internships.length,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                itemBuilder: (context, index) =>
                                    _buildListItem(_internships[index], false),
                              ),
                            ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
