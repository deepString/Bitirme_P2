import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/client/client_cubit.dart';
import 'bloc/favorites/favorites_cubit.dart';
import 'engine/routes.dart';
import 'engine/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ClientCubit(
            ClientState(language: "tr", darkMode: false),
          ),
        ),
        BlocProvider(
          create: (context) => FavoritesCubit(
            FavoritesState(favoritesMusic: []),
          ),
        ),
      ],
      child: BlocBuilder<ClientCubit, ClientState>(builder: (context, state) {
        return MaterialApp.router(
          title: 'Music App',
          debugShowCheckedModeBanner: false,
          routerConfig: routes,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: darkTheme,
        );
      }),
    );
  }
}
