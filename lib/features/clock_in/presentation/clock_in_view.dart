import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:workmate_mobile/core/components/custom_bottom_sheet.dart';
import 'package:workmate_mobile/core/components/main_button.dart';
import 'package:workmate_mobile/core/theme/colors.dart';
import 'package:workmate_mobile/core/theme/typography.dart';
import 'package:workmate_mobile/features/clock_in/attendance/bloc/attendance_bloc.dart';
import 'package:workmate_mobile/features/clock_in/attendance/cubit/attendance_status_cubit.dart';
import 'package:workmate_mobile/features/clock_in/attendance/cubit/face_recog_status_cubit.dart';
import 'package:workmate_mobile/features/clock_in/attendance/model/attendance_today_status.dart';
import 'package:workmate_mobile/features/clock_in/attendance/model/face_recog_status.dart';

class ClockInView extends StatefulWidget {
  const ClockInView({super.key});

  @override
  State<ClockInView> createState() => _ClockInViewState();
}

class _ClockInViewState extends State<ClockInView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F3F8),
      body: Stack(
        children: [
          Container(
            height: 233,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xff7155FF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 28),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Let’s Clock-In!",
                              style: HeadlineText.headlineSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              "Don’t miss your clock in schedule",
                              style: LabelText.labelLarge.copyWith(
                                color: PurpleColors.purple200,
                              ),
                            ),
                            const SizedBox(width: 7),
                          ],
                        ),
                        const Spacer(),
                        Image.asset(
                          "assets/icons/attendant-illus.png",
                          height: 78,
                          width: 94,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.only(right: 12, left: 12),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Working Hour",
                            style: LabelText.labelLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Paid Period 1 Sept 2024 - 30 Sept 2024",
                            style: BodyText.bodySmall.copyWith(
                              color: const Color(0xff475467),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            spacing: 8,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: GrayColors.grey50,
                                    ),
                                    color: const Color(0xffF9F9F9),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 10,
                                    children: [
                                      Row(
                                        spacing: 4,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/clock.svg",
                                            height: 16,
                                            width: 16,
                                          ),
                                          Text(
                                            "Today",
                                            style: LabelText.labelMedium
                                                .copyWith(
                                                  color: TextColors
                                                      .textSecondaryColor,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "00:00 Hrs",
                                        style: HeadlineText.headlineSmall
                                            .copyWith(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: GrayColors.grey50,
                                    ),
                                    color: const Color(0xffF9F9F9),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 10,
                                    children: [
                                      Row(
                                        spacing: 4,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/clock.svg",
                                            height: 16,
                                            width: 16,
                                          ),
                                          Text(
                                            "This Pay Period",
                                            style: LabelText.labelMedium
                                                .copyWith(
                                                  color: TextColors
                                                      .textSecondaryColor,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "32:00 Hrs",
                                        style: HeadlineText.headlineSmall
                                            .copyWith(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildClockInButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 16);
                  },
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "27 September 2024",
                            style: LabelText.labelLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: TextColors.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: GrayColors.grey50),
                              color: const Color(0xffF9F9F9),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 4,
                                  children: [
                                    Row(
                                      spacing: 4,
                                      children: [
                                        Text(
                                          "Total Hours",
                                          style: LabelText.labelMedium.copyWith(
                                            color:
                                                TextColors.textSecondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "08:00:00 hrs",
                                      style: HeadlineText.headlineSmall
                                          .copyWith(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 4,
                                  children: [
                                    Row(
                                      spacing: 4,
                                      children: [
                                        Text(
                                          "Clock in & Out",
                                          style: LabelText.labelMedium.copyWith(
                                            color:
                                                TextColors.textSecondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "09:00 AM  — 05:00 PM",
                                      style: HeadlineText.headlineSmall
                                          .copyWith(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SizedBox _buildClockInButton() {
    var faceRecogStatus = context.watch<FaceRecogStatusCubit>().state;
    var attendanceStatus = context.read<AttendanceStatusCubit>().state;

    void showRegisterBottomSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (context) {
          return CustomBottomSheet();
        },
      );
    }

    return SizedBox(
      width: double.infinity,
      child: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceSuccess) {
            switch (attendanceStatus) {
              case AttendanceTodayStatus.idle:
                return MainButton(
                  isDisabled: false,
                  onTap: () {
                    if (faceRecogStatus == FaceRecogStatus.error) {
                      showRegisterBottomSheet();
                    } else if (faceRecogStatus == FaceRecogStatus.success) {
                      context.push("/clockin/area-page");
                    }
                  },
                  text: "Clock In",
                  padding: const EdgeInsets.symmetric(vertical: 14),
                );
              case AttendanceTodayStatus.clockedIn:
                return Text("CLOCKED IN 1");
              case AttendanceTodayStatus.clockedOut:
                return Text("CLOCKED OUT 1");
              case AttendanceTodayStatus.onBreak:
                return Text("ON BREAK 1");
            }
          } else if (state is AttendanceError) {
            return Text("TERJADI KESALAHAN");
          } else {
            return MainButton(
              isDisabled: true,
              onTap: () {},
              text: "Clock In",
              padding: const EdgeInsets.symmetric(vertical: 14),
            );
          }
        },
      ),
    );
  }
}
