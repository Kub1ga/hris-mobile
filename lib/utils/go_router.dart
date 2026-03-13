import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workmate_mobile/features/clock_in/cubit/location_cubit.dart';
import 'package:workmate_mobile/features/clock_in/presentation/clock_in_area_page.dart';
import 'package:workmate_mobile/features/clock_in/presentation/clock_in_view.dart';
import 'package:workmate_mobile/features/clock_in/presentation/flow/preview_clock_in_page.dart';
import 'package:workmate_mobile/features/clock_in/presentation/flow/selfie_clock_in_page.dart';
import 'package:workmate_mobile/features/home/presentation/main_page.dart';
import 'package:workmate_mobile/features/navbar/cubit/navbar_cubit.dart';
import 'package:workmate_mobile/features/notifications/presentations/notification_page.dart';
import 'package:workmate_mobile/features/register/presentation/register_page.dart';
import 'package:workmate_mobile/features/register_face/presentation/preview_face_page.dart';
import 'package:workmate_mobile/features/register_face/presentation/register_face_page.dart';
import 'package:workmate_mobile/main.dart';

import '../features/clock_in/face_clock_in_bloc/face_clockin_bloc.dart';
import '../features/register_face/bloc/register_face_bloc.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingPage()),
    GoRoute(
      path: '/home',
      builder: (context, state) => BlocProvider(
        create: (context) => NavbarCubit(),
        child: const MainPage(),
      ),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationPage(),
    ),
    GoRoute(
      path: '/clockin',
      builder: (context, state) => const ClockInView(),
      routes: [
        GoRoute(
          path: "area-page",
          builder: (context, state) => BlocProvider(
            create: (context) => LocationCubit(),
            child: const ClockInAreaPage(),
          ),
        ),
        GoRoute(
          path: "selfie-page",
          builder: (context, state) => BlocProvider(
            create: (_) => FaceClockinBloc()..add(InitializeCamera()),
            child: const SelfieClockInPage(),
          ),
        ),
        GoRoute(
          path: "preview-page",
          builder: (context, state) {
            final imageBytes = state.extra as Uint8List;
            return PreviewClockInPage(imageBytes: imageBytes);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        return RegisterPage();
      },
    ),
    GoRoute(
      path: '/register-face',
      builder: (context, state) {
        return BlocProvider(
          create: (context) =>
              RegisterFaceBloc()..add(InitializeRegisterCamera()),
          child: RegisterFacePage(),
        );
      },
      routes: [
        GoRoute(
          path: "preview-face",
          builder: (context, state) {
            final imageBytes = state.extra as Uint8List;
            return PreviewFacePage(image: imageBytes);
          },
        ),
      ],
    ),
  ],
);
