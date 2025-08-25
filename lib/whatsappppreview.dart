import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:image/image.dart' as img;

class WhatsappStylePdfPreview extends StatefulWidget{
  final String pdfAssetPath;
  final String fileName;
  final String fileInfo;

  const WhatsappStylePdfPreview({
    Key? key,
    required this.pdfAssetPath,
    this.fileName = 'Deepak_Kumawat_Resume.pdf',
    this.fileInfo = '1 page  •  134 KB  •  pdf',
      }) : super(key: key);

  @override
  State<WhatsappStylePdfPreview> createState() => _WhatsappStylePdfPreviewState();
}

class _WhatsappStylePdfPreviewState extends State<WhatsappStylePdfPreview> {
  Uint8List? _thumbnailBytes;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  // In _loadThumbnail, crop a specific region from the top of the first page
  Future<void> _loadThumbnail() async {
    try {
      final doc = await PdfDocument.openAsset(widget.pdfAssetPath);
      final page = await doc.getPage(1);
      // Render a tall enough image to allow cropping the desired region from the top
      final renderHeight = 1200; // High resolution for clarity
      final pageImage = await page.render(
        width: 800, // Increase width for clarity as well
        height: renderHeight.toDouble(),
        format: PdfPageImageFormat.png,
      );
      // Decode the PNG
      final decoded = img.decodeImage(pageImage!.bytes);
      if (decoded == null) throw Exception('Failed to decode image');
      // Crop the top region (e.g., top 1/4 of the page)
      final cropHeight = renderHeight ~/ 4; // Change this for a different region size
      final cropped = img.copyCrop(
        decoded,
        x: 0,
        y: 0,
        width: decoded.width,
        height: cropHeight,
      );
      // Encode back to PNG
      final croppedBytes = img.encodePng(cropped);
      setState(() {
        _thumbnailBytes = Uint8List.fromList(croppedBytes);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load PDF preview.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => FullPdfViewerPage(pdfAssetPath: widget.pdfAssetPath),
        ));
      },
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.only(top: 80,left: 16, right: 16),
        decoration: BoxDecoration(
          color: Color(0xffe6f9eb),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              child: Container(
                color: Colors.white,
                height: 120.0,
                width: double.infinity,
                child: _errorMessage != null
                    ? Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)))
                    : _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _thumbnailBytes != null
                            ? Image.memory(
                                _thumbnailBytes!,
                                height: 120.0,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Center(child: Icon(Icons.picture_as_pdf, size: 40, color: Colors.red)),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.red, size: 34),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.fileName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.fileInfo,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Full PDF Viewer Page
class FullPdfViewerPage extends StatelessWidget {
  final String pdfAssetPath;
  const FullPdfViewerPage({Key? key, required this.pdfAssetPath}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Preview")),
      body: PdfView(
        controller: PdfController(
          document: PdfDocument.openAsset(pdfAssetPath),
        ),
      ),
    );
  }
}
