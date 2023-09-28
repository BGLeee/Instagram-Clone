import 'package:flutter/material.dart';
import 'package:instagram_clone/config/route/on_generate_route.dart';
import 'package:instagram_clone/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/credentials/sign_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'features/presentation/cubit/user/cubit/user_cubit.dart';
import 'features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'features/presentation/pages/main_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ic.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ic.sl<AuthCubit>()..appStarted(context)),
        BlocProvider(create: (_) => ic.sl<CredentialCubit>()),
        BlocProvider(create: (_) => ic.sl<UserCubit>()),
        BlocProvider(create: (_) => ic.sl<GetSingleUserCubit>()),
      ],
      child: MaterialApp(
        title: 'Instagram Clone',
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: OnGenerateRoute.route,
        initialRoute: "/",
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainScreen(
                    uid: authState.uid,
                  );
                } else {
                  return const SignInPage();
                }
              },
            );
          }
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
