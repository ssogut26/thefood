import 'package:flutter/material.dart';
import 'package:thefood/services/network_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('theFood'),
      ),
      body: FutureBuilder(
        future: NetworkManager.instance.getAreas(),
        builder: (context, snapshot) {
          return const Center(
            child: Text('Hello World'),
          );
        },
      ),
    );
  }
}
