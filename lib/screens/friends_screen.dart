import 'package:flutter/material.dart';
import '../services/mock_database.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allUsers = ['Charlie', 'Dave', 'Eve', 'Frank'];

  List<String> get _searchResults {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return [];
    return _allUsers
        .where((u) =>
            u.toLowerCase().contains(query) && !MockDatabase.friends.contains(u) && !MockDatabase.pendingRequests.contains(u))
        .toList();
  }

  void _sendFriendRequest(String name) {
    setState(() {
      if (!MockDatabase.pendingRequests.contains(name)) {
        MockDatabase.pendingRequests.add(name);
      }
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Friends'),
        actions:[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: (){
              Navigator.pushNamed(context, '/friendRequests');
            },
          )],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search username or ID',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            if (_searchResults.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Search Results',
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final name = _searchResults[index];
                  return ListTile(
                    leading: _avatarForName(name),
                    title: Text(name),
                    trailing: IconButton(
                      icon: const Icon(Icons.person_add),
                      onPressed: () => _sendFriendRequest(name),
                    ),
                  );
                },
              ),
              const Divider(),
            ],
            Align(
              alignment: Alignment.centerLeft,
              child:
                  Text('Your Friends', style: Theme.of(context).textTheme.titleSmall),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: MockDatabase.friends.length,
                itemBuilder: (context, index) {
                  final name = MockDatabase.friends[index];
                  return ListTile(
                    leading: _avatarForName(name),
                    title: Text(name),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/chat', arguments: name);
                      },
                      child: const Text('Message'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarForName(String name) {
    return CircleAvatar(
      child: Text(name.substring(0, 1)),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 