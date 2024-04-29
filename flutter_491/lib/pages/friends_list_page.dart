import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/pages/friend_profile.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttermoji/fluttermojiFunctions.dart';

class FriendsListPage extends StatefulWidget {
  const FriendsListPage({Key? key}) : super(key: key);

  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  List<String> _friendsList = []; // Assuming friends are stored as user IDs
  List<String> _filteredFriendsList = []; // List to store filtered friends
  List<DocumentSnapshot> _friendRequests = []; // List to store friend requests
  String? _currentUserUid; // Variable to store current user's UID

  @override
  void initState() {
    super.initState();
    _fetchFriendsList();
    _fetchFriendRequests();
    _getCurrentUserUid();
  }

  Future<void> _fetchFriendsList() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userData.exists) {
          final userDataMap = userData.data() as Map<String, dynamic>?;

          // Check if 'friends' field exists, if not, add it with an empty array
          if (userDataMap != null && !userDataMap.containsKey('friends')) {
            await userData.reference.update({'friends': []});
          }

          setState(() {
            _friendsList = List<String>.from(userData['friends'] ?? []);
            _filteredFriendsList = _friendsList; // Initially, set filtered list to all friends
          });
        }
      }
    } catch (e) {
      print('Error fetching friends list: $e');
    }
  }

  Future<void> _fetchFriendRequests() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('friend_requests')
            .where('receiver_id', isEqualTo: user.uid)
            .where('status', isEqualTo: 'pending')
            .get();
        setState(() {
          _friendRequests = querySnapshot.docs;
        });
      }
    } catch (e) {
      print('Error fetching friend requests: $e');
    }
  }

  Future<void> _getCurrentUserUid() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserUid = user.uid;
      });
    }
  }

  void _showAddFriendsDialog(BuildContext context) {
    TextEditingController _userIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Friends'),
          content: TextField(
            controller: _userIdController,
            decoration: InputDecoration(
              hintText: 'Enter friend\'s user ID',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final friendId = _userIdController.text.trim();
                  if (friendId.isNotEmpty) {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      // Check if the friend request already exists
                      final existingRequest = await FirebaseFirestore.instance
                          .collection('friend_requests')
                          .where('sender_id', isEqualTo: user.uid)
                          .where('receiver_id', isEqualTo: friendId)
                          .get();

                      if (existingRequest.docs.isEmpty) {
                        // Create a new friend request
                        await FirebaseFirestore.instance.collection('friend_requests').add({
                          'sender_id': user.uid,
                          'receiver_id': friendId,
                          'status': 'pending',
                          'timestamp': Timestamp.now(),
                        });
                      } else {
                        print('Friend request already sent');
                      }
                    }
                  }
                } catch (e) {
                  print('Error sending friend request: $e');
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

void _acceptFriendRequest(String requestId) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Get the friend request document
      final requestSnapshot = await FirebaseFirestore.instance.collection('friend_requests').doc(requestId).get();
      if (requestSnapshot.exists) {
        // Update the friend request status to "accepted"
        await requestSnapshot.reference.update({'status': 'accepted'});

        // Add each other as friends
        final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final friendDocRef = FirebaseFirestore.instance.collection('users').doc(requestSnapshot['sender_id']);

        final userDoc = await userDocRef.get();
        final friendDoc = await friendDocRef.get();

        final List<String> userFriends = List<String>.from(userDoc['friends'] ?? []);
        final List<String> friendFriends = List<String>.from(friendDoc['friends'] ?? []);

        if (!userFriends.contains(requestSnapshot['sender_id'])) {
          userFriends.add(requestSnapshot['sender_id']);
          await userDocRef.update({'friends': userFriends});
        }
        if (!friendFriends.contains(user.uid)) {
          friendFriends.add(user.uid);
          await friendDocRef.update({'friends': friendFriends});
        }

        // Fetch updated friend list and friend requests
        _fetchFriendsList();
        _fetchFriendRequests();
      }
    }
  } catch (e) {
    print('Error accepting friend request: $e');
  }
}

  void _rejectFriendRequest(String requestId) async {
    try {
      // Delete the friend request
      await FirebaseFirestore.instance.collection('friend_requests').doc(requestId).delete();

      // Fetch updated friend requests
      _fetchFriendRequests();
    } catch (e) {
      print('Error rejecting friend request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Friends',
             style: TextStyle(color: Colors.white,)
          ),
          backgroundColor: Colors.blue[700],
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(
              child: Text(
                'Friends',
                style: TextStyle(
                  color: Colors.white, // Set the color to white
                ),
              ),
            ),
            Tab(
              child: Text(
                'Requests',
                style: TextStyle(
                  color: Colors.white, // Set the color to white
                ),
              ),
            ),
            ],
          ),
          bottomOpacity: 1, // Ensure the bottom tab bar is fully opaque
        ),
        body: TabBarView(
          children: [
            // Friends Tab
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredFriendsList.length,
                    itemBuilder: (context, index) {
                      final friendId = _filteredFriendsList[index];
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('users').doc(friendId).get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return ListTile(
                              title: Text('Loading...'),
                            );
                          }
                          if (snapshot.hasError) {
                            return ListTile(
                              title: Text('Error: ${snapshot.error}'),
                            );
                          }
                          if (!snapshot.hasData || snapshot.data == null) {
                            return ListTile(
                              title: Text('No data available'),
                            );
                          }

                          final userData = snapshot.data!.data() as Map<String, dynamic>;
                          final userName = '${userData['firstName']} ${userData['lastName']}';
                          final fluttermojiUrl = userData['fluttermoji'] ?? '';

                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color.fromARGB(255, 238, 238, 238),
                                child: SvgPicture.string(
                                  FluttermojiFunctions()
                                      .decodeFluttermojifromString(fluttermojiUrl ?? ''),
                                    ),
                              ),
                              title: Text(
                                userName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('${userData['email']}'),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FriendProfilePage(userId: friendId),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            // Friend Requests Tab
            ListView.builder(
              itemCount: _friendRequests.length,
              itemBuilder: (context, index) {
                final friendRequest = _friendRequests[index];
                return ListTile(
                  title: Text('Friend Request from ${friendRequest['sender_id']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _acceptFriendRequest(friendRequest.id),
                        icon: Icon(Icons.check),
                        color: Colors.green,
                      ),
                      IconButton(
                        onPressed: () => _rejectFriendRequest(friendRequest.id),
                        icon: Icon(Icons.close),
                        color: Colors.red,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                _showAddFriendsDialog(context);
              },
              tooltip: 'Add Friend',
              child: Icon(Icons.add),
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () {
                if (_currentUserUid != null) {
                  Clipboard.setData(ClipboardData(text: _currentUserUid!)); // Copy UID to clipboard
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Your User ID: $_currentUserUid'),
                      duration: Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              tooltip: 'Copy User ID',
              child: Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}