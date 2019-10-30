import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n/generated/i18n.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final i18n = I18n.delegate;

  @override
  void initState() {
    super.initState();
    I18n.onLocaleChanged = onLocaleChange;
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      I18n.locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => I18n.of(context).title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        i18n,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: i18n.supportedLocales,
      localeResolutionCallback:
          i18n.resolution(fallback: new Locale('en', 'US')),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Locale locale;
  void _changeLanguage() {
    Locale myLocale = locale ?? Localizations.localeOf(context);
    String lang = myLocale.toString();
    String languageCode = myLocale.languageCode;
    print('changeLanguage lang: $lang, language: $languageCode');

    if (languageCode == 'zh') {
      myLocale = Locale('en');
    } else {
      myLocale = Locale('zh');
    }
    I18n.onLocaleChanged(myLocale);
    setState(() {
      locale = myLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              I18n.of(context).message,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeLanguage,
        tooltip: I18n.of(context).language,
        child: Icon(Icons.language),
      ),
    );
  }
}
