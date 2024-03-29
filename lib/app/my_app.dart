import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injectable/injectable.dart';
import 'package:shoplistapp/app/cubit/auth_cubit.dart';
import 'package:shoplistapp/app/cubit/verification_cubit.dart';
import 'package:shoplistapp/app/injection_container.dart';
import 'package:shoplistapp/app/auth/login/login_page.dart';
import 'package:shoplistapp/app/auth/verification/verification_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop List',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.transparent,
        canvasColor: const Color.fromARGB(255, 2, 116, 209),
      ),
      home: const RootPage(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  int splashtime = 3;

  @override
  void initState() {
    Future.delayed(Duration(seconds: splashtime), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const RootPage();
      }));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  Color.fromARGB(255, 200, 233, 255),
                  Color.fromARGB(255, 213, 238, 255),
                  Color.fromARGB(255, 228, 244, 255),
                  Color.fromARGB(255, 244, 250, 255),
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: ClipOval(
                      child: AnimatedSize(
                        clipBehavior: Clip.antiAlias,
                        curve: Curves.decelerate,
                        duration: const Duration(seconds: 3),
                        child: ClipOval(
                            child: Image.asset('images/icon/app_icon_2.png')),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Shop List App',
                      style: GoogleFonts.getFont(
                        'Saira',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 200, 233, 255),
                        shadows: <Shadow>[
                          const Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 7.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'by Sebastian Girsza',
                              style: GoogleFonts.getFont('Saira',
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'version 1.0.0',
                              style: GoogleFonts.getFont('Saira',
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ])));
  }
}

@injectable
class RootPage extends StatelessWidget {
  const RootPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>()..start(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = state.user;

          if (user == null) {
            return LoginPage();
          }
          return BlocProvider(
            create: (context) => getIt<VerificationCubit>(),
            child: BlocBuilder<VerificationCubit, VerificationState>(
              builder: (context, state) {
                return BlocListener<VerificationCubit, VerificationState>(
                  listener: (context, state) {
                    if (state.sent == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Wystąpił błąd. Spróbuj ponownie później.'),
                        ),
                      );
                    }
                    if (state.sent == false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Email z linkiem aktywacyjnym został wysłany.'),
                        ),
                      );
                    }
                  },
                  child: const VerifyEmailPage(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
