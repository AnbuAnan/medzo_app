import 'package:medzo/model/content_info.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/strings.dart';

class ContentItems {
  List<ContentInfo> contents = [
    ContentInfo(
      image: Images.onBoardingImg1,
      title: Strings.onboardingHeadLine1,
      descriptions: Strings.onboardingDescription1,
    ),
    ContentInfo(
      image: Images.onBoardingImg2,
      title: Strings.onboardingHeadLine2,
      descriptions: Strings.onboardingDescription2,
    ),
    ContentInfo(
      image: Images.onBoardingImg3,
      title: Strings.onboardingHeadLine3,
      descriptions: Strings.onboardingDescription3,
    ),
  ];
}
