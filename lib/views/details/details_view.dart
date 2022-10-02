import 'package:flutter/material.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({
    super.key,
    required this.name,
    required this.image,
  });

  final String? name;
  final String? image;

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name ?? ''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.network(widget.image ?? ''),
            Text('Here is the recipies for ${widget.name}'),
          ],
        ),
      ),
    );
  }
}
