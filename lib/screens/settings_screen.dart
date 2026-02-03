import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../services/language_service.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  final Function(Locale) onLanguageChanged;

  const SettingsScreen({
    super.key,
    required this.onLanguageChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Color bg = Color(0xFF0A0A0A);
  static const Color cardBg = Color(0xFF161B22);
  static const Color accentGreen = Color(0xFF7DD3A8);
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF7D8590);
  static const Color borderColor = Color(0xFF21262D);

  late String _selectedLanguage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final language = await LanguageService.getSelectedLanguage();
    setState(() {
      _selectedLanguage = language;
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

  Future<void> _showResetConfirmation() async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          loc.resetAllData,
          style: GoogleFonts.inter(
            color: textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          loc.resetAllDataConfirm,
          style: GoogleFonts.inter(
            color: textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              loc.cancel,
              style: GoogleFonts.inter(color: textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              loc.reset,
              style: GoogleFonts.inter(
                color: const Color(0xFFF85149),
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          loc.settings,
          style: GoogleFonts.inter(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: accentGreen),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Langue
                  Text(
                    loc.languageSection,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLanguageCard('en', 'English', '🇬🇧'),
                  const SizedBox(height: 12),
                  _buildLanguageCard('fr', 'Français', '🇫🇷'),
                  const SizedBox(height: 12),
                  _buildLanguageCard('ja', '日本語', '🇯🇵'),
                  const SizedBox(height: 40),

                  // À propos
                  Text(
                    loc.aboutSection,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Moto v1.0.0',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          loc.appDescription,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Danger Zone
                  Text(
                    loc.dangerZone,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _showResetConfirmation,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFF85149).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF85149).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.delete_forever_outlined,
                                color: Color(0xFFF85149),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loc.resetAllData,
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFFF85149),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    loc.resetAllDataDescription,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildLanguageCard(String code, String name, String flag) {
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
            color: isSelected ? accentGreen.withValues(alpha: 0.1) : cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? accentGreen.withValues(alpha: 0.5)
                  : borderColor,
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
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      code.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: accentGreen,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
