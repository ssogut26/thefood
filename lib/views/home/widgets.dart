part of 'home_view.dart';

class _ImageBox extends StatelessWidget {
  const _ImageBox({
    required this.url,
  }) : super();

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: 100,
      height: 100,
    );
  }
}

class _AlignedText extends StatelessWidget {
  const _AlignedText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}

class _CardBox extends StatelessWidget {
  const _CardBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.2,
      child: child,
    );
  }
}