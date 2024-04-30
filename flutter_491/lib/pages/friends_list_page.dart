import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttermoji/fluttermojiFunctions.dart';
import 'package:flutter_491/pages/friend_profile.dart';

class FriendsListPage extends StatefulWidget {
  const FriendsListPage({Key? key}) : super(key: key);

  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> with SingleTickerProviderStateMixin {
  List<String> _friendsList = [];
  List<String> _filteredFriendsList = [];
  List<DocumentSnapshot> _friendRequests = [];
  String? _currentUserUid;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _fetchFriendsList(); // Fetch friends list initially
    _fetchFriendRequests(); // Fetch friend requests initially
    _getCurrentUserUid(); // Fetch current user's UID initially
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        // Refresh data when tab is changed
        _fetchFriendsList();
        _fetchFriendRequests();
      });
    }
  }

  Future<void> _fetchFriendsList() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userData.exists) {
          final userDataMap = userData.data() as Map<String, dynamic>?;

          if (userDataMap != null && !userDataMap.containsKey('friends')) {
            await userData.reference.update({'friends': []});
          }

          setState(() {
            _friendsList = List<String>.from(userData['friends'] ?? []);
            _filteredFriendsList = _friendsList;
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
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(_currentUserUid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AlertDialog(
              title: Text('Add Friends'),
              content: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return AlertDialog(
              title: Text('Add Friends'),
              content: Text('Error fetching user data'),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final userName = '${userData['firstName']} ${userData['lastName']}';

          return AlertDialog(
            title: Text('Add Friends'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Send a friend request to $userName'),
                TextField(
                  controller: _userIdController,
                  decoration: InputDecoration(
                    hintText: 'Enter friend\'s user ID',
                  ),
                ),
              ],
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
                        final existingRequest = await FirebaseFirestore.instance
                            .collection('friend_requests')
                            .where('sender_id', isEqualTo: user.uid)
                            .where('receiver_id', isEqualTo: friendId)
                            .get();

                        if (existingRequest.docs.isEmpty) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Friends'),
            Tab(text: 'Requests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsTab(),
          _buildRequestsTab(),
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
                Clipboard.setData(ClipboardData(text: _currentUserUid!));
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
    );
  }

  Widget _buildFriendsTab() {
    return Column(
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
    );
  }

  Widget _buildRequestsTab() {
    return ListView.builder(
      itemCount: _friendRequests.length,
      itemBuilder: (context, index) {
        final friendRequest = _friendRequests[index];
        return Card( // Wrap the ListTile inside a Card
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Add margin for spacing
          child: ListTile(
            title: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(friendRequest['sender_id']).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Text('Error fetching sender data');
                }

                final senderData = snapshot.data!.data() as Map<String, dynamic>;
                final senderName = '${senderData['firstName']} ${senderData['lastName']}';

                return Text('Friend Request from $senderName');
              },
            ),
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
          ),
        );
      },
    );
  }
}