import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'l10n/app_localizations.dart';
import 'screens/splash_screen.dart';
import 'services/language_service.dart';
import 'services/notification_service.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  runApp(const MotoApp());
}

class MotoApp extends StatefulWidget {
  const MotoApp({super.key});

  @override
  State<MotoApp> createState() => _MotoAppState();
}

class _MotoAppState extends State<MotoApp> {
  Locale? _locale;
  bool _isDarkMode = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final language = await LanguageService.getSelectedLanguage();
    final isDark = await ThemeService.isDarkMode();
    setState(() {
      _locale = Locale(language);
      _isDarkMode = isDark;
      _isLoading = false;
    });
    _updateSystemUI();
  }

  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness: _isDarkMode ? Brightness.light : Brightness.dark,
      ),
    );
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void _changeTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
    _updateSystemUI();
  }

  ThemeData get _darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: MotoColors.darkBg,
    cardColor: MotoColors.darkCardBg,
    textTheme: GoogleFonts.interTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ),
    extensions: [MotoColors.dark],
  );

  ThemeData get _lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: MotoColors.lightBg,
    cardColor: MotoColors.lightCardBg,
    textTheme: GoogleFonts.interTextTheme(
      ThemeData(brightness: Brightness.light).textTheme,
    ),
    extensions: [MotoColors.light],
  );

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        title: 'Moto',
        debugShowCheckedModeBanner: false,
        theme: _darkTheme,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: MotoColors.darkAccentGreen),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Moto',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: _isDarkMode ? _darkTheme : _lightTheme,
      home: SplashScreen(
        onLanguageChanged: _changeLanguage,
        onThemeChanged: _changeTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

// Centralized color definitions
class MotoColors {
  // Dark theme colors
  static const Color darkBg = Color(0xFF0A0A0A);
  static const Color darkCardBg = Color(0xFF161B22);
  static const Color darkTextPrimary = Color(0xFFE6EDF3);
  static const Color darkTextSecondary = Color(0xFF7D8590);
  static const Color darkBorderColor = Color(0xFF21262D);
  static const Color darkAccentGreen = Color(0xFF7DD3A8);
  static const Color darkDanger = Color(0xFFF85149);
  static const Color darkEmptySquare = Color(0xFF21262D);
  static const Color darkEmptyBorder = Color(0xFF30363D);

  // Light theme colors - Modern, soft, not too bright
static const Color lightBg = Color(0xFFF2EFEA);        // beige minéral
static const Color lightCardBg = Color(0xFFECE7DF);   // carte ton sur ton (pas blanc)
static const Color lightTextPrimary = Color(0xFF2F343C);   // gris graphite lisible
static const Color lightTextSecondary = Color(0xFF7A8088); // gris mécanique doux
static const Color lightBorderColor = Color(0xFFD8D2C8);   // séparation subtile
static const Color lightEmptySquare = Color(0xFFD8D2C8);
static const Color lightEmptyBorder = Color(0xFFCBC4B9);
static const Color lightAccentGreen = Color(0xFF7BC7B3);   // vert “moto eco / flow”
static const Color lightDanger = Color(0xFFE29A8F);        // rouge frein, adouci




  static const MotoTheme dark = MotoTheme(
    bg: darkBg,
    cardBg: darkCardBg,
    textPrimary: darkTextPrimary,
    textSecondary: darkTextSecondary,
    borderColor: darkBorderColor,
    accentGreen: darkAccentGreen,
    danger: darkDanger,
    emptySquare: darkEmptySquare,
    emptyBorder: darkEmptyBorder,
  );

  static const MotoTheme light = MotoTheme(
    bg: lightBg,
    cardBg: lightCardBg,
    textPrimary: lightTextPrimary,
    textSecondary: lightTextSecondary,
    borderColor: lightBorderColor,
    accentGreen: lightAccentGreen,
    danger: lightDanger,
    emptySquare: lightEmptySquare,
    emptyBorder: lightEmptyBorder,
  );
}

// Custom theme extension for Moto colors
class MotoTheme extends ThemeExtension<MotoTheme> {
  final Color bg;
  final Color cardBg;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;
  final Color accentGreen;
  final Color danger;
  final Color emptySquare;
  final Color emptyBorder;

  const MotoTheme({
    required this.bg,
    required this.cardBg,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
    required this.accentGreen,
    required this.danger,
    required this.emptySquare,
    required this.emptyBorder,
  });

  @override
  MotoTheme copyWith({
    Color? bg,
    Color? cardBg,
    Color? textPrimary,
    Color? textSecondary,
    Color? borderColor,
    Color? accentGreen,
    Color? danger,
    Color? emptySquare,
    Color? emptyBorder,
  }) {
    return MotoTheme(
      bg: bg ?? this.bg,
      cardBg: cardBg ?? this.cardBg,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      borderColor: borderColor ?? this.borderColor,
      accentGreen: accentGreen ?? this.accentGreen,
      danger: danger ?? this.danger,
      emptySquare: emptySquare ?? this.emptySquare,
      emptyBorder: emptyBorder ?? this.emptyBorder,
    );
  }

  @override
  MotoTheme lerp(ThemeExtension<MotoTheme>? other, double t) {
    if (other is! MotoTheme) return this;
    return MotoTheme(
      bg: Color.lerp(bg, other.bg, t)!,
      cardBg: Color.lerp(cardBg, other.cardBg, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      accentGreen: Color.lerp(accentGreen, other.accentGreen, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      emptySquare: Color.lerp(emptySquare, other.emptySquare, t)!,
      emptyBorder: Color.lerp(emptyBorder, other.emptyBorder, t)!,
    );
  }
}
