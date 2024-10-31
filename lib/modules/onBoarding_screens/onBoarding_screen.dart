import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:todo/layout/layout_cubit/todo_cubit.dart';
import 'package:todo/layout/layout_screen.dart';
import 'package:todo/models/onBoarding_model.dart';
import 'package:todo/shared/components/components.dart';
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

  int value = 0;

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
            : TextButton(
                child: Text(
                  AppStrings.skip,
                  style: GoogleFonts.lato(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: AppColors.deepGrey,
                  ),
                ),
                onPressed: () {
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
          child: Text(
            onBoardingModel.title,
            style: GoogleFonts.lato(fontSize: 32, fontWeight: FontWeight.w700),
          ),
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
                : TextButton(
                    onPressed: () {
                      pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastEaseInToSlowEaseOut,
                      );
                    },
                    child: Text(
                      AppStrings.back,
                      style: GoogleFonts.lato(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: AppColors.deepGrey,
                      ),
                    ),
                  ),
            const Spacer(),
            defaultButton(
              text: index == 2 ? AppStrings.getStarted : AppStrings.next,
              voidCall: () {
                if (index == 2) {
                  navigateAndFinish(
                    context: context,
                    widget: LayoutScreen(),
                  );
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
