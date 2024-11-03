import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:todo/layout/layout_screen.dart';
import 'package:todo/models/onBoarding_model.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/network/local/get_helper.dart';
import 'package:todo/shared/network/local/shared_helper.dart';
import 'package:todo/shared/styles/app_assets.dart';
import 'package:todo/shared/styles/colors.dart';
import 'package:todo/shared/styles/strings.dart';

PageController pageController = PageController();

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final List<OnBoardingModel> pages = [
    OnBoardingModel(
      title: AppStrings.onBoardingTitleOne,
      image: AppAssets.onBoarding1,
      subTitle: AppStrings.onBoardingSubTitleOne,
    ),
    OnBoardingModel(
      title: AppStrings.onBoardingTitleTwo,
      image: AppAssets.onBoarding2,
      subTitle: AppStrings.onBoardingSubTitleTwo,
    ),
    OnBoardingModel(
      title: AppStrings.onBoardingTitleThree,
      image: AppAssets.onBoarding3,
      subTitle: AppStrings.onBoardingSubTitleThree,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PageView.builder(
                  itemBuilder: (context, index) {
                    return onBoardingItem(pages[index], index, context);
                  },
                  controller: pageController,
                  itemCount: pages.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget onBoardingItem(
        OnBoardingModel onBoardingModel, int index, BuildContext context) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        index == 2
            ? Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(),
              )
            : commonTextButton(
                text: AppStrings.skip,
                textStyle: Theme.of(context).textTheme.displaySmall,
                function: () {
                  pageController.jumpToPage(2);
                },
              ),
        Center(
          child: Image(
            image: AssetImage(onBoardingModel.image),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Center(
          child: SmoothPageIndicator(
            controller: pageController,
            count: 3,
            effect: const ExpandingDotsEffect(
              activeDotColor: AppColors.purpleColor,
              dotHeight: 8,
              spacing: 8,
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Center(
          child: Text(onBoardingModel.title,
              style: Theme.of(context).textTheme.displayMedium),
        ),
        const SizedBox(
          height: 42,
        ),
        Center(
          child: Text(
            onBoardingModel.subTitle,
            style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            index == 0
                ? Container()
                : commonTextButton(
                    text: AppStrings.back,
                    textStyle: Theme.of(context).textTheme.displaySmall,
                    function: () {
                      pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastEaseInToSlowEaseOut,
                      );
                    },
                  ),
            const Spacer(),
            defaultButton(
              text: index == 2 ? AppStrings.getStarted : AppStrings.next,
              voidCall: () {
                if (index == 2) {
                  getIt<SharedHelper>()
                      .saveData(key: 'isOnBoarding', value: true)
                      .then((onValue) {
                    navigateAndFinish(
                      context: context,
                      widget: LayoutScreen(),
                    );
                  }).catchError((error) {
                    debugPrint('Error saving data: $error');
                  });
                } else {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastEaseInToSlowEaseOut,
                  );
                }
              },
              width: 90,
              color: AppColors.purpleColor,
            ),
          ],
        ),
      ],
    );
