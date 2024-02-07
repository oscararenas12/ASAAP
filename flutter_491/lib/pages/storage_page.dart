import 'package:flutter/material.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoragePage extends StatefulWidget {
  @override
  _StoragePageState createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  List<String> folders = [];

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  void _loadFolders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      folders = prefs.getStringList('folders') ?? [];
    });
  }

  void _saveFolders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('folders', folders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkblue,
        title: Text('Storage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: folders.length,
          itemBuilder: (context, index) {
            return _buildFolderCard(folders[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.darkblue,
        onPressed: () {
          _showCreateFolderDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildFolderCard(String folderName) {
    return Card(
      color: AppColors.darkblue,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Icon(Icons.folder, color: Colors.white, size: 25)), // Adjust the size as needed
                SizedBox(height: 10),
                Text(
                  folderName,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 15), // Adjust the size as needed
              onPressed: () {
                _showFolderMenu(folderName);
              },
            ),
          ),
        ],
      ),
    );
  }


  void _showFolderMenu(String folderName) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: AppColors.lighterBlue,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.delete, color: AppColors.darkblue),
                title: Text('Remove'),
                onTap: () {
                  setState(() {
                    folders.remove(folderName);
                    _saveFolders(); // Save folders after removal
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCreateFolderDialog() {
    TextEditingController folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Folder'),
          content: TextField(
            controller: folderNameController,
            decoration: InputDecoration(
              hintText: 'Enter folder name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String folderName = folderNameController.text.trim();
                if (folderName.isNotEmpty) {
                  setState(() {
                    folders.add(folderName);
                    _saveFolders(); // Save folders after creation
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
