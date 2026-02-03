import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/language_service.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../services/theme_service.dart';
import 'onboarding_screen.dart';

class SettingsScreen extends StatefulWidget {
  final Function(Locale) onLanguageChanged;
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const SettingsScreen({
    super.key,
    required this.onLanguageChanged,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedLanguage;
  late bool _isDarkMode;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final language = await LanguageService.getSelectedLanguage();
    final isDark = await ThemeService.isDarkMode();
    setState(() {
      _selectedLanguage = language;
      _isDarkMode = isDark;
      _isLoading = false;
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    await LanguageService.setSelectedLanguage(languageCode);
    setState(() {
      _selectedLanguage = languageCode;
    });
    widget.onLanguageChanged(Locale(languageCode));
  }

  Future<void> _changeTheme(bool isDark) async {
    await ThemeService.setDarkMode(isDark);
    setState(() {
      _isDarkMode = isDark;
    });
    widget.onThemeChanged(isDark);
  }

  Future<void> _showResetConfirmation() async {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context).extension<MotoTheme>()!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          loc.resetAllData,
          style: GoogleFonts.inter(
            color: theme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          loc.resetAllDataConfirm,
          style: GoogleFonts.inter(
            color: theme.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              loc.cancel,
              style: GoogleFonts.inter(color: theme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              loc.reset,
              style: GoogleFonts.inter(
                color: theme.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await StorageService.clearAll();
      await NotificationService.cancelAllReminders();
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  Future<void> _sendFeedback() async {
    final loc = AppLocalizations.of(context)!;
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'rachoucorp@gmail.com',
      query: 'subject=${Uri.encodeComponent(loc.feedbackSubject)}',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback: try launching without checking
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open email client')),
        );
      }
    }
  }

  Future<void> _shareApp() async {
    final loc = AppLocalizations.of(context)!;
    await SharePlus.instance.share(ShareParams(text: loc.shareMessage));
  }

  Future<void> _replayOnboarding() async {
    final navigator = Navigator.of(context);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', false);
    if (mounted) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => OnboardingScreen(
            onLanguageChanged: widget.onLanguageChanged,
            onThemeChanged: widget.onThemeChanged,
            isDarkMode: _isDarkMode,
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context).extension<MotoTheme>()!;

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          loc.settings,
          style: GoogleFonts.inter(
            color: theme.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: theme.accentGreen),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Apparence
                  _buildSectionTitle(loc.appearanceSection, theme),
                  const SizedBox(height: 16),
                  _buildThemeSelector(theme),
                  const SizedBox(height: 40),

                  // Section Langue
                  _buildSectionTitle(loc.languageSection, theme),
                  const SizedBox(height: 16),
                  _buildLanguageCard('en', 'English', '🇬🇧', theme),
                  const SizedBox(height: 12),
                  _buildLanguageCard('fr', 'Français', '🇫🇷', theme),
                  const SizedBox(height: 12),
                  _buildLanguageCard('ja', '日本語', '🇯🇵', theme),
                  const SizedBox(height: 40),

                  // Section Support
                  _buildSectionTitle(loc.supportSection, theme),
                  const SizedBox(height: 16),
                  _buildActionCard(
                    theme: theme,
                    icon: Icons.mail_outline,
                    iconColor: theme.accentGreen,
                    title: loc.sendFeedback,
                    subtitle: loc.sendFeedbackDescription,
                    onTap: _sendFeedback,
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    theme: theme,
                    icon: Icons.share_outlined,
                    iconColor: theme.accentGreen,
                    title: loc.shareApp,
                    subtitle: loc.shareAppDescription,
                    onTap: _shareApp,
                  ),
                  const SizedBox(height: 40),

                  // À propos
                  _buildSectionTitle(loc.aboutSection, theme),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: theme.cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: theme.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Moto v1.0.0',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          loc.appDescription,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: theme.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActionCard(
                    theme: theme,
                    icon: Icons.replay_outlined,
                    iconColor: theme.textSecondary,
                    title: loc.replayOnboarding,
                    subtitle: '',
                    onTap: () => _replayOnboarding(),
                  ),
                  const SizedBox(height: 40),

                  // Danger Zone
                  _buildSectionTitle(loc.dangerZone, theme),
                  const SizedBox(height: 16),
                  _buildActionCard(
                    theme: theme,
                    icon: Icons.delete_forever_outlined,
                    iconColor: theme.danger,
                    iconBgColor: theme.danger.withValues(alpha: 0.1),
                    title: loc.resetAllData,
                    titleColor: theme.danger,
                    subtitle: loc.resetAllDataDescription,
                    borderColor: theme.danger.withValues(alpha: 0.3),
                    onTap: _showResetConfirmation,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title, MotoTheme theme) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: theme.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildThemeSelector(MotoTheme theme) {
    final loc = AppLocalizations.of(context)!;
    // Use colors based on current _isDarkMode state for immediate visual feedback
    final currentTheme = _isDarkMode ? MotoColors.dark : MotoColors.light;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: currentTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: currentTheme.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildThemeOption(
              currentTheme: currentTheme,
              icon: Icons.dark_mode_outlined,
              label: loc.darkMode,
              isSelected: _isDarkMode,
              onTap: () => _changeTheme(true),
            ),
          ),
          Expanded(
            child: _buildThemeOption(
              currentTheme: currentTheme,
              icon: Icons.light_mode_outlined,
              label: loc.lightMode,
              isSelected: !_isDarkMode,
              onTap: () => _changeTheme(false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required MotoTheme currentTheme,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? currentTheme.accentGreen.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? currentTheme.accentGreen : currentTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? currentTheme.accentGreen : currentTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(String code, String name, String flag, MotoTheme theme) {
    final isSelected = _selectedLanguage == code;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _changeLanguage(code),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? theme.accentGreen.withValues(alpha: 0.1) : theme.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? theme.accentGreen.withValues(alpha: 0.5)
                  : theme.borderColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(
                flag,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.textPrimary,
                      ),
                    ),
                    Text(
                      code.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: theme.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: theme.accentGreen,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required MotoTheme theme,
    required IconData icon,
    required Color iconColor,
    Color? iconBgColor,
    required String title,
    Color? titleColor,
    required String subtitle,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor ?? theme.borderColor,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor ?? iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: titleColor ?? theme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: theme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
