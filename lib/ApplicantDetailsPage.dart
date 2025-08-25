import 'dart:ui';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'widget/ApplicantCard.dart';
import 'PdfViewerPage.dart';

class ApplicantDetailsPage extends StatelessWidget {
  final Applicant applicant;
  const ApplicantDetailsPage({Key? key, required this.applicant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applicant Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  child: Text(applicant.name.isNotEmpty ? applicant.name[0] : '?', style: TextStyle(fontSize: 36)),
                ),
              ),
              SizedBox(height: 24),
              Text('Name:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(applicant.name, style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              Text('Job Title:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(applicant.jobTitle, style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(applicant.status.isEmpty ? 'N/A' : applicant.status, style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('Location:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(applicant.location.isNotEmpty ? applicant.location : 'Unknown', style: TextStyle(fontSize: 18)),
              SizedBox(height: 24),
              Text('Contact Information:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Email: johndoe@email.com', style: TextStyle(fontSize: 16)),
              Text('Phone: +1 234 567 890', style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Text('Skills:', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: [
                  Chip(label: Text('Flutter')),
                  Chip(label: Text('Dart')),
                  Chip(label: Text('Firebase')),
                  Chip(label: Text('UI/UX')),
                ],
              ),
              SizedBox(height: 16),
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
              SizedBox(height: 16),
              Text('Application Timeline:', style: TextStyle(fontWeight: FontWeight.bold)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Applied'),
                    subtitle: Text('2025-08-01'),
                  ),
                  ListTile(
                    leading: Icon(Icons.timelapse, color: Colors.orange),
                    title: Text('Interview Scheduled'),
                    subtitle: Text('2025-08-10'),
                  ),
                  ListTile(
                    leading: Icon(Icons.pending, color: Colors.grey),
                    title: Text('Pending Decision'),
                    subtitle: Text('2025-08-15'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Strong communication skills. Good portfolio.', style: TextStyle(color: Colors.indigo[900])),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.check, color: Colors.white),
                    label: Text('Accept', style: TextStyle(color: Colors.white)),
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
                    label: Text('Reject', style: TextStyle(color: Colors.white)),
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
              SizedBox(height: 16),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    pageCount != null ? '$pageCount page${pageCount == 1 ? '' : 's'}' : '--',
                    style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                  ),
                  Text(' • ', style: TextStyle(fontSize: 12, color: Colors.grey[800])),
                  Text(
                    fileSize != null ? '${(fileSize! / 1024).toStringAsFixed(0)} KB' : '--',
                    style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                  ),
                  Text(' • pdf', style: TextStyle(fontSize: 12, color: Colors.grey[800])),
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
