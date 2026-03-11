import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:workmate_mobile/core/theme/colors.dart';
import 'package:workmate_mobile/core/theme/typography.dart';

import '../../../core/components/main_button.dart';
import '../cubit/location_cubit.dart';

class ClockInAreaPage extends StatefulWidget {
  const ClockInAreaPage({super.key});

  @override
  State<ClockInAreaPage> createState() => _ClockInAreaPageState();
}

class _ClockInAreaPageState extends State<ClockInAreaPage> {
  final MapController _mapController = MapController(
    initPosition: GeoPoint(latitude: -6.277878, longitude: 106.635743),
  );

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<LocationCubit>().updateLocation(null);
    Future.delayed(const Duration(seconds: 1), () async {
      await _mapController.drawCircle(
        CircleOSM(
          key: "office_area",
          centerPoint: GeoPoint(latitude: -6.277878, longitude: 106.635743),
          radius: 200, // meter
          color: PurpleColors.purple400.withOpacity(0.3),
          strokeWidth: 2,
          borderColor: PurpleColors.purple400,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 300,
            child: OSMFlutter(
              controller: _mapController,
              osmOption: OSMOption(
                zoomOption: ZoomOption(initZoom: 16),
                userTrackingOption: UserTrackingOption(
                  enableTracking: true,
                  unFollowUser: true,
                ),
              ),
              onLocationChanged: (p) {
                context.read<LocationCubit>().updateLocation(p);
              },
            ),
          ),

          Positioned(
            top: 52,
            left: 23.5,
            child: InkWell(
              onTap: () => context.pop(),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PurpleColors.purple50,
                ),
                child: SvgPicture.asset("assets/icons/back_icon.svg"),
              ),
            ),
          ),

          BlocBuilder<LocationCubit, GeoPoint?>(
            builder: (context, state) {
              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 350,
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 15,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 16),
                        width: double.infinity,
                        height: 96,
                        decoration: BoxDecoration(
                          color:
                              context.read<LocationCubit>().insideOffice ==
                                      false ||
                                  context.read<LocationCubit>().state == null
                              ? const Color(0xffF95555)
                              : const Color(0xff795FFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                Text(
                                  context.read<LocationCubit>().insideOffice ==
                                              false ||
                                          context.read<LocationCubit>().state ==
                                              null
                                      ? "You are not in the clock-in area!"
                                      : "You are in the clock-in area!",
                                  style: TitleText.titleMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  context.read<LocationCubit>().insideOffice ==
                                              false ||
                                          context.read<LocationCubit>().state ==
                                              null
                                      ? "Please get into the office area"
                                      : "Now you can press clock in in this area",
                                  style: TitleText.titleMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: -23,
                              top: 10,
                              bottom: -10,
                              child: Image.asset(
                                "assets/icons/attendant-illus.png",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "MY PROFILE",
                        style: LabelText.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: GrayColors.grey50),
                          color: const Color(0xffF9F9F9),
                        ),
                        child: Row(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                color: PurpleColors.purple300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Arya Batara Sena",
                                    style: TitleText.titleMedium.copyWith(
                                      color: const Color(0xff2D2D2D),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "29 September 2024",
                                    style: BodyText.bodySmall.copyWith(
                                      color: PurpleColors.purple500,
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  if (state == null)
                                    Text(
                                      "Getting location",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: LabelText.labelMedium,
                                    )
                                  else
                                    Text(
                                      "Lat ${context.read<LocationCubit>().state?.latitude}  Long ${context.read<LocationCubit>().state?.longitude}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: LabelText.labelMedium,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<LocationCubit, GeoPoint?>(
        builder: (context, state) {
          if (state == null) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              height: 76,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: GrayColors.grey300, width: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xffAA9FFE).withAlpha(0),
                    offset: const Offset(0, -105),
                    spreadRadius: 0,
                    blurRadius: 29,
                  ),
                  BoxShadow(
                    color: const Color(0xffAA9FFE).withAlpha(1),
                    offset: const Offset(0, -67),
                    spreadRadius: 0,
                    blurRadius: 27,
                  ),
                  BoxShadow(
                    color: const Color(0xffAA9FFE).withAlpha(5),
                    offset: const Offset(0, -38),
                    spreadRadius: 0,
                    blurRadius: 23,
                  ),
                  BoxShadow(
                    color: const Color(0xffAA9FFE).withAlpha(9),
                    offset: const Offset(0, -17),
                    spreadRadius: 0,
                    blurRadius: 17,
                  ),
                  BoxShadow(
                    color: const Color(0xffAA9FFE).withAlpha(80),
                    offset: const Offset(0, -4),
                    spreadRadius: 9,
                    blurRadius: 100,
                  ),
                ],
              ),
              child: MainButton(
                onTap: () {},
                text: "Selfie To Clock In",
                isDisabled: true,
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            height: 76,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: GrayColors.grey300, width: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffAA9FFE).withAlpha(0),
                  offset: const Offset(0, -105),
                  spreadRadius: 0,
                  blurRadius: 29,
                ),
                BoxShadow(
                  color: const Color(0xffAA9FFE).withAlpha(1),
                  offset: const Offset(0, -67),
                  spreadRadius: 0,
                  blurRadius: 27,
                ),
                BoxShadow(
                  color: const Color(0xffAA9FFE).withAlpha(5),
                  offset: const Offset(0, -38),
                  spreadRadius: 0,
                  blurRadius: 23,
                ),
                BoxShadow(
                  color: const Color(0xffAA9FFE).withAlpha(9),
                  offset: const Offset(0, -17),
                  spreadRadius: 0,
                  blurRadius: 17,
                ),
                BoxShadow(
                  color: const Color(0xffAA9FFE).withAlpha(80),
                  offset: const Offset(0, -4),
                  spreadRadius: 9,
                  blurRadius: 100,
                ),
              ],
            ),
            child: MainButton(
              onTap: () {
                context.push('/clockin/selfie-page');
              },
              text: "Selfie To Clock In",
              // isDisabled: context.read<LocationCubit>().insideOffice == false,
            ),
          );
        },
      ),
    );
  }
}
