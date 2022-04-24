import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_sample/providers/store.dart';

class UserDetailPage extends StatefulWidget {
  final int id;
  final String url;
  const UserDetailPage({
    Key? key,
    required this.id,
    required this.url,
  }) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  void initState() {
    super.initState();
    final store = Provider.of<Store>(context, listen: false);
    store.getUserDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<Store>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(store.user?.name ?? 'User Detail Page'),
      ),
      body: store.loading
          ? const Center(
              child: Text("Loading..."),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: ListView(
                children: [
                  CircleAvatar(
                    radius: 60,
                    child: ClipOval(
                      child: Image.network(
                        widget.url,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildItem(
                    Icons.person_outline_rounded,
                    store.user?.name,
                  ),
                  const SizedBox(height: 20),
                  _buildItem(
                    Icons.account_circle_outlined,
                    store.user?.username,
                  ),
                  const SizedBox(height: 20),
                  _buildItem(
                    Icons.email_outlined,
                    store.user?.email,
                  ),
                  const SizedBox(height: 20),
                  _buildItem(
                    Icons.phone,
                    store.user?.phone,
                  ),
                  const SizedBox(height: 20),
                  _buildItem(
                    Icons.social_distance_rounded,
                    store.user?.website,
                  ),
                  const SizedBox(height: 20),
                  _buildItem(
                    Icons.work_outline_rounded,
                    store.user?.company?.name,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildItem(IconData icon, String? title) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFFF5F6F9),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: const Color(0xFFFF7643),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title ?? "",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      );
}
