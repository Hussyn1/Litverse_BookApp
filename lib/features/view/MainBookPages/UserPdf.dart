import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UserPdfReaderPage extends StatefulWidget {
  final String bookTitle;
  final String pdfUrl;
  final String coverImageUrl;
  final String genre;

  const UserPdfReaderPage({
    super.key,
    required this.bookTitle,
    required this.pdfUrl,
    required this.coverImageUrl,
    required this.genre,
  });

  @override
  State<UserPdfReaderPage> createState() => _UserPdfReaderPageState();
}

class _UserPdfReaderPageState extends State<UserPdfReaderPage> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool _showControls = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.bookTitle,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'IBMPlexSansCondensed',
          ),
        ),
        backgroundColor: const Color(0xffF25C2B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showControls ? Icons.fullscreen : Icons.fullscreen_exit),
            onPressed: () {
              setState(() {
                _showControls = !_showControls;
              });
            },
            tooltip: _showControls ? 'Hide Controls' : 'Show Controls',
          ),
        ],
      ),
      body: Column(
        children: [
          // PDF Controls Bar
          if (_showControls)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xffF4E6D3),
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Book Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reading",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontFamily: 'IBMPlexSansCondensed',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.bookTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'IBMPlexSansCondensed',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // Zoom Controls
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.zoom_out, size: 20),
                          onPressed: () {
                            _pdfViewerController.zoomLevel = 
                                _pdfViewerController.zoomLevel - 0.25;
                          },
                          tooltip: 'Zoom Out',
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey[300],
                        ),
                        IconButton(
                          icon: const Icon(Icons.zoom_in, size: 20),
                          onPressed: () {
                            _pdfViewerController.zoomLevel = 
                                _pdfViewerController.zoomLevel + 0.25;
                          },
                          tooltip: 'Zoom In',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
          // PDF Viewer
          Expanded(
            child: widget.pdfUrl.isNotEmpty
                ? SfPdfViewer.network(
                    widget.pdfUrl,
                    controller: _pdfViewerController,
                    enableDoubleTapZooming: true,
                    enableTextSelection: true,
                    canShowScrollHead: true,
                    canShowScrollStatus: true,
                    onDocumentLoadFailed: (details) {
                      
                      // Show error dialog
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Failed to Load PDF"),
                              content: Text(
                                "Unable to load the book.\n\nError: ${details.error}\n\nPlease check your internet connection or try again later.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); 
                                    Navigator.pop(context); 
                                  },
                                  child: const Text("Go Back"),
                                ),
                              ],
                            ),
                          );
                        }
                      });
                    },
                    onDocumentLoaded: (details) {
                  
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.picture_as_pdf,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "PDF not available",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontFamily: 'IBMPlexSansCondensed',
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "The book file could not be loaded",
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'IBMPlexSansCondensed',
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffF25C2B),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Go Back"),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}