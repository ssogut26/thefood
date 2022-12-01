import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/core/constants/colors.dart';
import 'package:thefood/core/constants/paddings.dart';

final currentPage = StateProvider((ref) => 0);

class OnboardView extends ConsumerWidget {
  const OnboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(currentPage);

    return Scaffold(
      body: IndexedStack(
        index: count,
        children: const [
          OnboardPage1(),
          OnboardPage2(),
          OnboardPage3(),
        ],
      ),
    );
  }
}

class OnboardPage1 extends ConsumerWidget {
  const OnboardPage1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: ProjectPaddings.pageLarge,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/add.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.6),
              child: Text('theFood', style: context.textTheme.headline1),
            ),
            Align(
              alignment: const Alignment(0, 0.5),
              child: Text(
                'Share your recipes with the world',
                style: context.textTheme.headline2,
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.6),
              child: Text(
                'Find the best recipes\nfrom around the world',
                style: context.textTheme.headline2,
              ),
            ),
            Align(
              alignment: const Alignment(1, 0.9),
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(currentPage.notifier).state++;
                },
                icon: const Icon(
                  Icons.arrow_forward,
                  color: ProjectColors.black,
                ),
                label: Text(
                  'Next',
                  style: context.textTheme.headline2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardPage2 extends ConsumerWidget {
  const OnboardPage2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.5,
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: ProjectPaddings.pageLarge,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/favorite.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment(0, -0.6),
                child: Text('theFood', style: TextStyle(fontSize: 25)),
              ),
              Align(
                alignment: const Alignment(0, 0.5),
                child: Text(
                  'Add to favorites for use later',
                  style: context.textTheme.headline3,
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.6),
                child: Text(
                  'It also works offline',
                  style: context.textTheme.headline3,
                ),
              ),
              Align(
                alignment: const Alignment(1, 0.9),
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.read(currentPage.notifier).state++;
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: ProjectColors.black,
                  ),
                  label: Text(
                    'Next',
                    style: context.textTheme.headline2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardPage3 extends StatelessWidget {
  const OnboardPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.5,
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: ProjectPaddings.pageLarge,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/share.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, -0.6),
                child: Text('theFood', style: context.textTheme.headline1),
              ),
              Align(
                alignment: const Alignment(0, 0.5),
                child: Text(
                  'Share your cooking experience\nand rate recipes',
                  style: context.textTheme.headline3,
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.6),
                child: Text(
                  'We are waiting for you',
                  style: context.textTheme.headline1,
                ),
              ),
              Align(
                alignment: const Alignment(1, 0.9),
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.goNamed('login');
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: ProjectColors.black,
                  ),
                  label: Text(
                    "Let's Cook",
                    style: context.textTheme.headline2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
