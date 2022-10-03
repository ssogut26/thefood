import 'package:flutter/material.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({
    this.id,
    this.image,
    super.key,
    required this.name,
  });
  final String? image;
  final String? name;
  final int? id;
  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name ?? ''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(widget.image ?? ''),
            Text('Here is the recipies for ${widget.name}'),
          ],
        ),
      ),
    );
  }
}
