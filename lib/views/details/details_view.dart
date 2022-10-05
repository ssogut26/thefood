import 'package:flutter/material.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/network_manager.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({
    this.image,
    required this.id,
    super.key,
    required this.name,
  });
  final String? image;
  final String name;
  final int id;
  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  late final Future<Meal?> _meals;

  @override
  void initState() {
    _meals = NetworkManager.instance.getMeal(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.image ?? ''),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: ProjectPaddings().pageLarge,
                child: Column(
                  children: [
                    FutureBuilder<Meal?>(
                      future: _meals,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.meals?.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Text(
                                    widget.name,
                                    style: Theme.of(context).textTheme.headline1,
                                  ),
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text('in '),
                                  )
                                ],
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
