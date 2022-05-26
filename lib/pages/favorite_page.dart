import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_sample/pages/user_detail_page.dart';
import 'package:provider_sample/providers/store.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    final store = Provider.of<Store>(context, listen: false);
    store.getFavorites();
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
        title: const Text('Favorite Page'),
      ),
      body: store.loading
          ? const Center(
              child: Text("Loading..."),
            )
          : RefreshIndicator(
              onRefresh: () => store.onRefreshFavorite(),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                itemCount: store.items.length,
                itemBuilder: (BuildContext context, int index) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/300?$index',
                    ),
                  ),
                  title: Text(store.items[index].name ?? ''),
                  subtitle: Text(store.items[index].email ?? ''),
                  onTap: () => store.items[index].id != null
                      ? _handleNavigateUserDetail(
                          store.items[index].id!,
                          'https://i.pravatar.cc/300?$index',
                        )
                      : null,
                ),
              ),
            ),
    );
  }
}
