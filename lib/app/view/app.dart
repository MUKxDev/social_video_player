import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaar_player/features/player/bloc/preload_bloc.dart';
import 'package:jaar_player/features/player/presentation/feed_page.dart';

import 'package:jaar_player/l10n/l10n.dart';
import 'package:jaar_player/service/injection.dart';
import 'package:jaar_player/service/navigation_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<PreloadBloc>()..add(const PreloadEvent.getVideosFromApi()),
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const FeedPage(),
        navigatorKey: getIt<NavigationService>().navigationKey,
      ),
    );
  }
}
