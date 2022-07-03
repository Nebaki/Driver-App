import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VehicleDocument extends StatefulWidget {
  static const routeName = "/vehicledocument";
  @override
  _VehicleDocumentState createState() => _VehicleDocumentState();
}

class _VehicleDocumentState extends State<VehicleDocument> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _isLoading1 = false;
  bool _isLoading2 = false;

  bool _userAborted = false;
  bool _multiPick = false;
  bool _isComplete = false;
  bool _isComplete1 = false;
  bool _isComplete2 = false;

  FileType _pickingType = FileType.any;
  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      //_isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  void _pickFiles(int index) async {
    _resetState();
    index == 0
        ? _isLoading = true
        : index == 1
            ? _isLoading1 = true
            : _isLoading2 = true;
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _isLoading1 = false;
      _isLoading2 = false;
      index == 0
          ? _isComplete == true
          : index == 1
              ? _isComplete1 = true
              : _isComplete2 = true;
      //_isLoading = false;
      //_isComplete = true;
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Vehicle Document",
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            _buildListItems(
              title: "Passport",
              index: 0,
              subtitle: "Vehicle Registration",
              widget: _isLoading
                  ? const CircularProgressIndicator()
                  : _isComplete
                      ? const Icon(Icons.clear)
                      : Text(
                          "UPLOAD",
                          style: _textStyle,
                        ),
            ),
            const Divider(),
            _buildListItems(
                title: "Passport",
                index: 1,
                subtitle: "Vehicle Registration",
                widget: _isLoading1
                    ? const CircularProgressIndicator()
                    : _isComplete1
                        ? const Icon(Icons.clear)
                        : Text(
                            "UPLOAD",
                            style: _textStyle,
                          )),
            const Divider(),
            _buildListItems(
                title: "Passport",
                subtitle: "Vehicle Registration",
                index: 2,
                widget: _isLoading2
                    ? const CircularProgressIndicator()
                    : _isComplete2
                        ? const Icon(Icons.clear)
                        : Text(
                            "UPLOAD",
                            style: _textStyle,
                          )),
            const Divider(),
            const SizedBox(
              height: 60,
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  "By continuing, iconfirm that i have read & agree to the Terms & conditions and Privacypolicy",
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Next",
                          style: TextStyle(color: Colors.white))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItems(
      {required String title,
      required String subtitle,
      required Widget widget,
      required int index}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: InkWell(
            onTap: () {
              _pickFiles(index);
            },
            child: widget),
      ),
    );
  }

  void _logException(String message) {
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  final _textStyle = TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
}
