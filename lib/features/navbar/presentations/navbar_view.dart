import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../cubit/navbar_cubit.dart';

class NavbarView extends StatefulWidget {
  final PageController controller;
  final int index;
  const NavbarView({super.key, required this.controller, required this.index});

  @override
  State<NavbarView> createState() => _NavbarViewState();
}

class _NavbarViewState extends State<NavbarView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      color: const Color(0xff1C2020),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  context.read<NavbarCubit>().changeIndex(0);
                  widget.controller.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: SvgPicture.asset(
                  widget.index == 0
                      ? "assets/icons/home-active.svg"
                      : "assets/icons/home.svg",
                  color: Colors.white,
                ),
              ),
              if (widget.index == 0)
                Container(height: 2, width: 12, color: Colors.white),
            ],
          ),
          Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  context.read<NavbarCubit>().changeIndex(1);
                  widget.controller.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: SvgPicture.asset(
                  widget.index == 1
                      ? "assets/icons/calendar-active.svg"
                      : "assets/icons/calendar.svg",
                  color: Colors.white,
                ),
              ),
              if (widget.index == 1)
                Container(height: 2, width: 12, color: Colors.white),
            ],
          ),
          Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  context.read<NavbarCubit>().changeIndex(2);
                  widget.controller.animateToPage(
                    2,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: SvgPicture.asset(
                  widget.index == 2
                      ? "assets/icons/note-active.svg"
                      : "assets/icons/note.svg",
                  color: Colors.white,
                ),
              ),
              if (widget.index == 2)
                Container(height: 2, width: 12, color: Colors.white),
            ],
          ),
          InkWell(
            onTap: () => widget.controller.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: SvgPicture.asset(
              "assets/icons/receipt.svg",
              color: Colors.white,
            ),
          ),
          InkWell(
            onTap: () => widget.controller.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: SvgPicture.asset(
              "assets/icons/layer.svg",
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
