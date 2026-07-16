import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hue_hunt/data/mission_repository.dart';
import 'package:hue_hunt/l10n/app_localizations.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';
import 'package:hue_hunt/providers/settings_provider.dart';
import 'package:hue_hunt/screens/app_entry_screen.dart';
import 'package:hue_hunt/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const HueHuntApp());
}

class HueHuntApp extends StatelessWidget {
  const HueHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()..load()),
        ChangeNotifierProvider(create: (_) => ExpeditionProvider(MissionRepository())),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'Room Raiders',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark,
            locale: settings.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (deviceLocale, supported) {
              if (settings.locale != null) return settings.locale;
              if (deviceLocale != null) {
                for (final supportedLocale in supported) {
                  if (supportedLocale.languageCode == deviceLocale.languageCode) {
                    return supportedLocale;
                  }
                }
              }
              return const Locale('en');
            },
            home: const AppEntryScreen(),
          );
        },
      ),
    );
  }
}
