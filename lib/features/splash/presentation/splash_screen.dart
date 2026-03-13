import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth/login/bloc/login_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    context.read<LoginBloc>().add(CheckRememberMe());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.pushReplacement("/home");
          }

          if (state is UnAuthenticated) {
            context.pushReplacement("/onboarding");
          }
        },
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
