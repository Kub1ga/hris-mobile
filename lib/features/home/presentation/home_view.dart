import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/components/common_button.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../profile/bloc/profile_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F3F8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(95),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: GrayColors.grey200)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return Text("LOADING");
                } else if (state is ProfileSuccess) {
                  return AppBar(
                    scrolledUnderElevation: 0,
                    backgroundColor: Colors.white,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.userProfileModels.email!,
                          style: TitleText.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          state.userProfileModels.role ?? "",
                          style: LabelText.labelMedium.copyWith(
                            color: const Color(0xff6E62FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    automaticallyImplyLeading: false,
                    actions: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xffF4F5FF),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset("assets/icons/messages.svg"),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          context.push("/notifications");
                        },
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xffF4F5FF),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            "assets/icons/notification.svg",
                          ),
                        ),
                      ),
                    ],
                    leading: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: PurpleColors.purple400,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            state.userProfileModels.profilePicture ?? '',
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Text("data");
              },
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            width: double.infinity,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xff795FFC),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today Meeting",
                  style: LabelText.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Your schedule for the day",
                  style: LabelText.labelMedium.copyWith(
                    color: const Color(0xff475467),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: GrayColors.grey100.withAlpha(30),
                    border: Border.all(color: GrayColors.grey200.withAlpha(40)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    spacing: 12,
                    children: [
                      Row(
                        spacing: 6,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/video_meet.svg",
                            height: 28,
                            width: 28,
                          ),
                          Expanded(
                            child: Text(
                              "Townhall Meeting",
                              style: LabelText.labelLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "01:30 AM - 02:00 AM",
                            style: LabelText.labelLarge,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            fit: StackFit.loose,
                            children: [
                              Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 14),
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  border: Border.all(color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 28),
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  border: Border.all(color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          CommonButton(
                            onTap: () {
                              print("Join Meet Tapped");
                            },
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 6,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: NavbarView(),
    );
  }
}
