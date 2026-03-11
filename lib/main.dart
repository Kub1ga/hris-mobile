import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workmate_mobile/core/components/main_button.dart';
import 'package:workmate_mobile/core/components/primary_button.dart';
import 'package:workmate_mobile/features/clock_in/cubit/location_cubit.dart';
import 'package:workmate_mobile/features/login/bloc/login_bloc.dart';
import 'package:workmate_mobile/features/login/cubit/login_state_cubit.dart';
import 'package:workmate_mobile/features/login/models/login_state.dart';
import 'package:workmate_mobile/features/navbar/cubit/navbar_cubit.dart';
import 'package:workmate_mobile/features/onboarding/cubit/carousel_cubit.dart';
import 'package:workmate_mobile/features/onboarding/models/onboarding_item.dart';

import 'core/theme/colors.dart';
import 'core/theme/typography.dart';
import 'features/login/presentation/login_bottom_sheet.dart';
import 'features/repository/auth_repository.dart';
import 'utils/go_router.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  Bloc.observer = const AppBlocObserver();
  _cameras = await availableCameras();

  runApp(
    MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (context) => AuthRepository())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                LoginBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(create: (context) => NavbarCubit()),
          BlocProvider(create: (context) => LocationCubit()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: appRouter);
  }
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final CarouselSliderController _controller = CarouselSliderController();

  final onboardingData = [
    OnboardingItem(
      image: "assets/onboarding/onboarding_one.png",
      title: "Welcome to Workmate!",
      description:
          "Make Smart Decisions! Set clear timelines for projects and celebrate your achievements!",
    ),
    OnboardingItem(
      image: "assets/onboarding/onboarding_two.png",
      title: "Manage Stress Effectively",
      description:
          "Stay Balanced! Track your workload and maintain a healthy stress level with ease.",
    ),
    OnboardingItem(
      image: "assets/onboarding/onboarding_three.png",
      title: "Plan for Success",
      description:
          "Your Journey Starts Here! Earn achievement badges as you conquer your tasks. Let’s get started!",
    ),
    OnboardingItem(
      image: "assets/onboarding/onboarding_fourth.png",
      title: "Navigate Your Work Journey Efficient & Easy",
      description:
          "Increase your work management & career development radically",
    ),
  ];

  void showLoginBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return BlocProvider(
          create: (context) => LoginStateCubit(),
          child: const LoginBottomSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarouselCubit(),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [PurpleColors.purple500, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            BlocBuilder<CarouselCubit, int>(
              builder: (context, state) {
                return Column(
                  children: [
                    CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                        viewportFraction: 1,
                        height: 700,
                        // onScrolled: (value) {},
                        onPageChanged: (index, reason) {
                          context.read<CarouselCubit>().changeIndicator(index);
                        },
                      ),
                      items: onboardingData.map((items) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 86,
                                left: 33,
                                right: 33,
                              ),
                              child: Image.asset(items.image),
                            ),
                            const SizedBox(height: 48),
                            Text(
                              items.title,
                              style: HeadlineText.headlineSmall.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 34,
                              ),
                              child: Text(
                                items.description,
                                style: PopUpText.popUpBody,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 4,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: onboardingData.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 20,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color:
                                  index == context.read<CarouselCubit>().state
                                  ? PurpleColors.purple500
                                  : PurpleColors.purple100,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 35),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      width: double.infinity,
                      child: MainButton(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        text: context.read<CarouselCubit>().isLastPage
                            ? "Sign In"
                            : "Next",
                        onTap: () {
                          if (state == 3) {
                            showLoginBottomSheet();
                          } else {
                            context.read<CarouselCubit>().nextPage(4);
                            _controller.nextPage();
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      width: double.infinity,
                      child: PrimaryButton(
                        text: context.read<CarouselCubit>().isLastPage
                            ? "Sign Up"
                            : "Skip",
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        onTap: () => _controller.animateToPage(3),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
