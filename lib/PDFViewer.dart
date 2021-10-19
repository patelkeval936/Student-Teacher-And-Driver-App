import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PdfViewer extends StatefulWidget {
  static final id = 'pdfViewerPage';

  final String path;
  const PdfViewer(this.path);

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

PdfDocument doc;
bool _isLoading = true;

class _PdfViewerState extends State<PdfViewer> {

  static final int _initialPage = 1;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;
  PdfController _pdfController;

  @override
  void initState() {

    _pdfController = PdfController(
      document: PdfDocument.openFile(widget.path.toString()).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      }),
      initialPage: _initialPage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () {
              _pdfController.previousPage(
                curve: Curves.ease,
                duration: Duration(milliseconds: 20),
              );
            },
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              '$_actualPageNumber/$_allPagesCount',
              style: TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              _pdfController.nextPage(
                curve: Curves.ease,
                duration: Duration(milliseconds: 20),
              );
            },
          ),
        ],
      ),
      body: Center(child: _isLoading ? Container() : PdfView(
        documentLoader: Center(child: CircularProgressIndicator()),
        pageLoader: Center(child: CircularProgressIndicator()),
        controller: _pdfController,
        onDocumentLoaded: (document) {
          setState(() {
            _allPagesCount = document.pagesCount;
          });
        },
        onPageChanged: (page) {
          setState(() {
            _actualPageNumber = page;
          });
        },
      )),
    );
  }
}
