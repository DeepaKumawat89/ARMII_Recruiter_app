// import 'package:flutter/material.dart';
// import 'package:pdfx/pdfx.dart';
//
// class WhatsappStylePdfPreview extends StatefulWidget {
//   final String pdfAssetPath;
//
//   const WhatsappStylePdfPreview({Key? key, required this.pdfAssetPath}) : super(key: key);
//
//   @override
//   State<WhatsappStylePdfPreview> createState() => _WhatsappStylePdfPreviewState();
// }
//
// class _WhatsappStylePdfPreviewState extends State<WhatsappStylePdfPreview> {
//   late PdfDocument pdfDocument;
//   bool initialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     PdfDocument.openAsset(widget.pdfAssetPath).then((doc) {
//       setState(() {
//         pdfDocument = doc;
//         initialized = true;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return initialized ? GestureDetector(
//         onTap: () {
//           // Open full pdf preview here
//         },
//         child: Container(
//           width: double.infinity,
//           margin: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Color(0xffe6f9eb),
//             borderRadius: BorderRadius.circular(18),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 6,
//               )
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(18),
//                   topRight: Radius.circular(18),
//                 ),
//                 child: Container(
//                   color: Colors.white,
//                   height: 110,
//                   width: double.infinity,
//                   child: PdfPageImage(
//                     pdfDocument: pdfDocument,
//                     pageNumber: 1,
//                     width: double.infinity.toInt(),
//                     height: 110,
//                     fit: BoxFit.fitWidth,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(Icons.picture_as_pdf, color: Colors.red, size: 34),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Deepak_Kumawat_Resume.pdf',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 16,
//                                 color: Colors.black87
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: 4),
//                           Text('1 page  •  134 KB  •  pdf',
//                             style: TextStyle(
//                               color: Colors.black54,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         )
//     ) : Center(child: CircularProgressIndicator());
//   }
// }
