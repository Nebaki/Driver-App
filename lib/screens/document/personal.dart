import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonalDocument extends StatefulWidget {
  static const routeName = "/personaldocument";
  @override
  _PersonalDocumentState createState() => _PersonalDocumentState();
}

// void _pickFile() async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles();

//   print(result);
// }

class _PersonalDocumentState extends State<PersonalDocument> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  bool _multiPick = false;
  bool _isComplete = false;
  FileType _pickingType = FileType.any;
  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  void _pickFiles() async {
    _resetState();
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
      _isComplete = true;
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
          "Personal Document",
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildListItems(title: "Passport", subtitle: "Vehicle Registration"),
          Divider(),
          _buildListItems(title: "Passport", subtitle: "Vehicle Registration"),
          Divider(),
          _buildListItems(title: "Passport", subtitle: "Vehicle Registration"),
          Divider(),
          SizedBox(
            height: 60,
          ),
          Divider(),
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
    );
  }

  Widget _current = const Text("UPLOAD");

  Widget _buildListItems({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: InkWell(
          onTap: () {

            _pickFiles();
          },
          onLongPress: () {
          },
          child: _isLoading
              ? CircularProgressIndicator()
              : _isComplete
                  ? Icon(Icons.clear)
                  : Text("UPLOAD"),
        ),
      ),
    );
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
