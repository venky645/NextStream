import 'package:flutter/material.dart';
import 'package:nexstream/models/admin_user_model.dart';
import 'package:nexstream/presentation/admin_page/widget/admin_statitics.dart';
import 'package:nexstream/services/api_service.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 2,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'User Management'),
              Tab(text: 'Admin Statistics'),
            ],
          ),
        ),
        drawer: AdminDrawer(),
        body: TabBarView(
          children: [UserManagement(), AdminStatistics()],
        ),
      ),
    );
  }
}

// Drawer Widget
class AdminDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Admin User'),
            accountEmail: Text('admin@nexstream.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
          ListTile(
            title: const Text('Dashboard'),
            leading: const Icon(Icons.dashboard),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminDashboard()),
              );
            },
          ),
          ListTile(
            title: const Text('User Management'),
            leading: const Icon(Icons.manage_accounts),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserManagement()),
              );
            },
          ),
          ListTile(
            title: const Text('Admin Statistics'),
            leading: const Icon(Icons.bar_chart),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminStatistics()),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  late ScrollController _scrollController;
  List<AdminUser> _users = [];
  Pagination? _pagination;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    _fetchUsers(1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers(int page) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService().fetchAdminUsers(page);
      final List<AdminUser> fetchedUsers = result['users'] as List<AdminUser>;
      final Pagination fetchedPagination = result['pagination'] as Pagination;

      setState(() {
        _users.addAll(fetchedUsers);
        _pagination = fetchedPagination;
      });
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        (_pagination?.hasNext ?? false)) {
      _fetchUsers((_pagination?.currentPage ?? 1) + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _users.length + (_pagination?.hasNext == true ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _users.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = _users[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Icon(
                user.statusId == 1 ? Icons.check_circle : Icons.error,
                color: user.statusId == 1 ? Colors.green : Colors.red,
              ),
              title: Text(user.name),
              subtitle: Text(user.email),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (user.statusId == 0)
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Activate'),
                    ),
                  if (user.statusId == 1)
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Suspend'),
                    ),
                  SizedBox(
                    width: 5,
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Deactivate'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
