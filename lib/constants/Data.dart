import 'package:exercise_tracker/constants/Path_const.dart';
import 'package:exercise_tracker/constants/Text_const.dart';

class DataConstants {
    // Onboarding
    static final onboardingTiles = [
        OnboardingTile(
            title: TextConstants.onboarding1Title,
            maintext: TextConstants.onboardingDescription,
            imagePath: PathConstants.onboarding1
        ),
        OnboardingTile(
            title: TextConstants.onboarding2Title,
            maintext: TextConstants.onboarding2Description,
            imagePath: PathConstants.onboarding2,
        ),
        OnboardingTile(
            title: TextConstants.onboarding3Title,
            maintext: TextConstants.onboarding3Description,
            imagePath: PathConstants.onboarding3
        )
    ];
}

class OnboardingTile {
  late String title;
  late String maintext;
  late String imagePath;
  
  OnboardingTile({required this.title,required this.maintext,required this.imagePath});
}