import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../theme/text_styles.dart';
import '../widgets/glass_card.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppColors.heroGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 24, offset: const Offset(0, 12))],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
                      ),
                      child: Center(
                        child: Text(
                          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                          style: AppTextStyles.display.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(user.name, style: AppTextStyles.h1.copyWith(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(user.email, style: AppTextStyles.body.copyWith(color: Colors.white.withOpacity(0.85))),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _StatTile(icon: Icons.cake_outlined, label: 'Age', value: '${user.age ?? '-'}')),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _StatTile(
                          icon: Icons.height_rounded, label: 'Height', value: user.height != null ? '${user.height} cm' : '-')),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _StatTile(
                          icon: Icons.monitor_weight_outlined,
                          label: 'Weight',
                          value: user.weight != null ? '${user.weight} kg' : '-')),
                ],
              ),
              const SizedBox(height: 16),
              SoftCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _SettingsTile(icon: Icons.event_rounded, title: 'Member Since', trailing: user.createdDate ?? '-'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(color: AppColors.error.withOpacity(0.4)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: Text('Log Out', style: AppTextStyles.body.copyWith(color: AppColors.error, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.h3),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String trailing;
  const _SettingsTile({required this.icon, required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.35), borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: AppColors.primaryDark, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500))),
          Text(trailing, style: AppTextStyles.bodyMuted),
        ],
      ),
    );
  }
}
