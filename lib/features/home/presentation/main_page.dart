import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmate_mobile/features/clock_in/presentation/clock_in_view.dart';
import 'package:workmate_mobile/features/home/presentation/home_view.dart';
import 'package:workmate_mobile/features/navbar/cubit/navbar_cubit.dart';
import 'package:workmate_mobile/features/navbar/presentations/navbar_view.dart';
import 'package:workmate_mobile/features/tasks/presentation/task_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics:
            const NeverScrollableScrollPhysics(), // optional (biar hanya navbar yang kontrol)
        children: const [HomeView(), ClockInView(), TaskView()],
      ),
      bottomNavigationBar: BlocBuilder<NavbarCubit, int>(
        builder: (context, state) {
          return NavbarView(controller: _controller, index: state);
        },
      ),
    );
  }
}
