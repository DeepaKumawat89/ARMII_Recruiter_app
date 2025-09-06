import 'dart:ui';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import '../../../widget/ApplicantCard.dart';
import '../../../widget/customroundedappbar.dart';
import 'PdfViewerPage.dart';

class ApplicantDetailsPage extends StatelessWidget {
  final Applicant applicant;
  const ApplicantDetailsPage({Key? key, required this.applicant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customRoundedAppBar(context, 'Applicant Details'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FA), Color(0xFFE4ECF7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            ),
                          ],
                          border: Border.all(color: Colors.blueAccent, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.blue[100],
                          child: Text(
                            applicant.name.isNotEmpty ? applicant.name[0] : '?',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900]
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 28),
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.blueAccent),
                      title: Text(
                        applicant.name,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      subtitle: Text(
                        'Name',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.grey[600]
                        )
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.work_outline, color: Colors.deepPurple),
                      title: Text(
                        applicant.jobTitle,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20
                        )
                      ),
                      subtitle: Text(
                        'Job Title',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.grey[600]
                        )
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.verified_user, color: Colors.green),
                      title: Text(
                        applicant.status.isEmpty ? 'N/A' : applicant.status,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20
                        )
                      ),
                      subtitle: Text(
                        'Status',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.grey[600]
                        )
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.redAccent),
                      title: Text(
                        applicant.location.isNotEmpty ? applicant.location : 'Unknown',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20
                        )
                      ),
                      subtitle: Text(
                        'Location',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.grey[600]
                        )
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Contact Information',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      )
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.blueGrey),
                        SizedBox(width: 8),
                        Text(
                          'johndoe@email.com',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16
                          )
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.blueGrey),
                        SizedBox(width: 8),
                        Text(
                          '+1 234 567 890',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16
                          )
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Skills',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      )
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 6.0,
                      children: [
                        Chip(
                          label: Text(
                            'Flutter',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.blue[900]
                            )
                          ),
                          backgroundColor: Colors.blue[50],
                          elevation: 2
                        ),
                        Chip(
                          label: Text(
                            'Dart',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.deepPurple
                            )
                          ),
                          backgroundColor: Colors.purple[50],
                          elevation: 2
                        ),
                        Chip(
                          label: Text(
                            'Firebase',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.deepOrange
                            )
                          ),
                          backgroundColor: Colors.orange[50],
                          elevation: 2
                        ),
                        Chip(
                          label: Text(
                            'UI/UX',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.green[900]
                            )
                          ),
                          backgroundColor: Colors.green[50],
                          elevation: 2
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    WhatsAppPdfPreviewCard(
                      assetPath: 'assets/pdf/Deepak_Kumawat_Resume.pdf',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerPage(
                              pdfAssetPath: 'assets/pdf/Deepak_Kumawat_Resume.pdf',
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Application Timeline',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      )
                    ),
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(Icons.check_circle, color: Colors.green),
                          title: Text(
                            'Applied',
                            style: TextStyle(fontFamily: 'Inter')
                          ),
                          subtitle: Text(
                            '2025-08-01',
                            style: TextStyle(fontFamily: 'Inter')
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.timelapse, color: Colors.orange),
                          title: Text(
                            'Interview Scheduled',
                            style: TextStyle(fontFamily: 'Inter')
                          ),
                          subtitle: Text(
                            '2025-08-10',
                            style: TextStyle(fontFamily: 'Inter')
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.pending, color: Colors.grey),
                          title: Text(
                            'Pending Decision',
                            style: TextStyle(fontFamily: 'Inter')
                          ),
                          subtitle: Text(
                            '2025-08-15',
                            style: TextStyle(fontFamily: 'Inter')
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Notes',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      )
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Strong communication skills. Good portfolio.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.indigo[900]
                        )
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.check, color: Colors.white),
                          label: Text(
                            'Accept',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.white
                            )
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.close, color: Colors.white),
                          label: Text(
                            'Reject',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.white
                            )
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.linked_camera, color: Colors.indigo),
                          onPressed: () {},
                          tooltip: 'LinkedIn',
                        ),
                        IconButton(
                          icon: Icon(Icons.code, color: Colors.grey[700]),
                          onPressed: () {},
                          tooltip: 'GitHub',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WhatsAppPdfPreviewCard extends StatefulWidget {
  final String assetPath;
  final void Function()? onTap;
  const WhatsAppPdfPreviewCard({Key? key, required this.assetPath, this.onTap}) : super(key: key);

  @override
  State<WhatsAppPdfPreviewCard> createState() => _WhatsAppPdfPreviewCardState();
}

class _WhatsAppPdfPreviewCardState extends State<WhatsAppPdfPreviewCard> {
  String? localPath;
  int? pageCount;
  int? fileSize;
  bool isLoading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  Future<void> loadPdf() async {
    try {
      final bytes = await rootBundle.load(widget.assetPath);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp_whatsapp_preview.pdf');
      await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
      setState(() {
        localPath = file.path;
        fileSize = file.lengthSync();
      });
    } catch (e) {
      setState(() {
        errorMsg = 'Failed to load PDF: $e';
        isLoading = false;
      });
    }
  }

  Widget _buildMetaRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.picture_as_pdf, color: Colors.red[700], size: 28),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deepak_Kumawat_Resume.pdf',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    pageCount != null ? '$pageCount page${pageCount == 1 ? '' : 's'}' : '--',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.grey[800]
                    ),
                  ),
                  Text(
                    ' • ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.grey[800]
                    )
                  ),
                  Text(
                    fileSize != null ? '${(fileSize! / 1024).toStringAsFixed(0)} KB' : '--',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.grey[800]
                    ),
                  ),
                  Text(
                    ' • pdf',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.grey[800]
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);
    if (errorMsg != null) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: borderRadius,
        ),
        child: Text(errorMsg!, style: TextStyle(color: Colors.red)),
      );
    }
    if (localPath == null) {
      return Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: borderRadius,
        ),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thumbnail placeholder
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[400]!, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.picture_as_pdf, color: Colors.red[700], size: 40),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 8),
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFFE7F8EF), // WhatsApp soft green
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: _buildMetaRow(),
          ),
        ],
      ),
    );
  }
}
