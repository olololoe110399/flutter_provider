import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_sample/pages/user_detail_page.dart';
import 'package:provider_sample/providers/store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final store = Provider.of<Store>(context, listen: false);
    store.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<Store>(context);

    _handleNavigateUserDetail(int id, String url) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserDetailPage(id: id, url: url),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: store.loading
          ? const Center(
              child: Text("Loading..."),
            )
          : RefreshIndicator(
              onRefresh: () => store.onRefresh(),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                itemCount: store.users.length,
                itemBuilder: (BuildContext context, int index) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/300?$index',
                    ),
                  ),
                  title: Text(store.users[index].name ?? ''),
                  subtitle: Text(store.users[index].email ?? ''),
                  onTap: () => store.users[index].id != null
                      ? _handleNavigateUserDetail(
                          store.users[index].id!,
                          'https://i.pravatar.cc/300?$index',
                        )
                      : null,
                ),
              ),
            ),
    );
  }
}
