import 'package:lottie/lottie.dart';
import 'package:thefood/core/constants/assets_path.dart';

class CustomLottieLoading extends LottieBuilder {
  CustomLottieLoading({
    super.key,
    String? path,
    bool animate = true,
    bool repeat = true,
    required Function onLoaded,
  }) : super.asset(
          path ?? AssetsPath.splash,
          animate: animate,
          repeat: repeat,
          onLoaded: (composition) {
            Future.delayed(
              composition.duration,
              () {
                onLoaded(composition);
              },
            );
          },
        );
}
