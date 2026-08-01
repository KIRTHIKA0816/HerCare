import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../theme/text_styles.dart';
import '../widgets/floating_nav_bar.dart';
import '../widgets/glass_card.dart';
import '../widgets/quick_action_tile.dart';
import '../widgets/section_title.dart';
import 'calendar_screen.dart';
import 'period_entry_screen.dart';
import 'symptom_screen.dart';
import 'pcod_screen.dart';
import 'nutrition_screen.dart';
import 'reminder_screen.dart';
import 'notes_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Map<String, dynamic>? _prediction;

  @override
  void initState() {
    super.initState();
    _loadPrediction();
  }

  // ---- Same prediction-loading logic as before ----
  Future<void> _loadPrediction() async {
    if (widget.user.userId == null) return;
    final prediction = await ApiService.predictNextPeriod(widget.user.userId!);
    if (mounted) setState(() => _prediction = prediction);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _DashboardTab(user: widget.user, prediction: _prediction, onRefresh: _loadPrediction),
      CalendarScreen(user: widget.user),
      NotesScreen(user: widget.user),
      ProfileScreen(user: widget.user),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: tabs[_currentIndex],
      bottomNavigationBar: FloatingNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
          NavItem(icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month_rounded, label: 'Calendar'),
          NavItem(icon: Icons.note_alt_outlined, activeIcon: Icons.note_alt_rounded, label: 'Notes'),
          NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
        ],
      ),
    );
  }
}

class _DashboardTab extends StatefulWidget {
  final UserModel user;
  final Map<String, dynamic>? prediction;
  final VoidCallback onRefresh;

  const _DashboardTab({
    required this.user,
    required this.prediction,
    required this.onRefresh,
  });

  @override
  State<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<_DashboardTab> {
  static const _tips = [
    "Stay hydrated 💧 — aim for 8 glasses today.",
    "Gentle stretching can ease cramps naturally.",
    "A balanced breakfast keeps your energy steady.",
    "7–8 hrs of sleep helps regulate your cycle.",
  ];

  String get _tipOfDay => _tips[DateTime.now().day % _tips.length];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: () async => widget.onRefresh(),
        color: AppColors.primary,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
          children: [
            _buildGreetingHeader(context),
            const SizedBox(height: 20),
            _buildRingCard(context),
            const SizedBox(height: 16),
            _buildWeekStreak(),
            const SizedBox(height: 16),
            if (widget.user.userId != null) WaterTrackerCard(userId: widget.user.userId!),
            const SizedBox(height: 22),
            const SectionTitle(title: 'Quick Actions', icon: Icons.bolt_rounded),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.25,
              children: [
                QuickActionTile(
                  icon: Icons.water_drop_rounded,
                  label: 'Track Period',
                  gradient: const [AppColors.primary, AppColors.primaryDark],
                  onTap: () async {
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (_) => PeriodEntryScreen(user: widget.user)));
                    widget.onRefresh();
                  },
                ),
                QuickActionTile(
                  icon: Icons.healing_rounded,
                  label: 'Symptoms',
                  gradient: const [Color(0xFF9B5DE5), Color(0xFF7C3AED)],
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SymptomScreen(user: widget.user))),
                ),
                QuickActionTile(
                  icon: Icons.calendar_month_rounded,
                  label: 'Calendar',
                  gradient: const [Color(0xFFFF8FAB), Color(0xFFFF4D8D)],
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => CalendarScreen(user: widget.user))),
                ),
                QuickActionTile(
                  icon: Icons.restaurant_rounded,
                  label: 'Nutrition',
                  gradient: const [Color(0xFF22C55E), Color(0xFF16A34A)],
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => NutritionScreen(user: widget.user))),
                ),
                QuickActionTile(
                  icon: Icons.favorite_rounded,
                  label: 'PCOD Health',
                  gradient: const [Color(0xFFF59E0B), Color(0xFFEA580C)],
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => PcodScreen(user: widget.user))),
                ),
                QuickActionTile(
                  icon: Icons.notifications_active_rounded,
                  label: 'Reminders',
                  gradient: const [Color(0xFF38BDF8), Color(0xFF0EA5E9)],
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ReminderScreen(user: widget.user))),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _buildTipCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingHeader(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good Morning' : (hour < 17 ? 'Good Afternoon' : 'Good Evening');
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(greeting, style: AppTextStyles.bodyMuted),
              const SizedBox(height: 2),
              Text('${widget.user.name} 🌸', style: AppTextStyles.h1),
            ],
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: AppColors.brandGradient),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              widget.user.name.isNotEmpty ? widget.user.name[0].toUpperCase() : '?',
              style: AppTextStyles.h2.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  /// Big circular-ring stat card — mirrors the reference "Activity" ring layout:
  /// large ring with two numbers in the middle, a legend row, and 3 stat chips below.
  Widget _buildRingCard(BuildContext context) {
    final prediction = widget.prediction;
    final cycleDay = prediction != null ? (prediction['current_cycle_day'] ?? 0) : 0;
    final daysUntil = prediction != null ? (prediction['days_until_next_period'] ?? 0) : 0;
    final cycleLenGuess = 28;
    final progress = cycleLenGuess > 0 ? ((cycleDay is num ? cycleDay : 0) / cycleLenGuess).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [BoxShadow(color: AppColors.shadowSoft, blurRadius: 22, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.favorite_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text('Cycle Overview', style: AppTextStyles.h3),
              const Spacer(),
              if (prediction == null)
                Text('No data yet', style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: 168,
            height: 168,
            child: CustomPaint(
              painter: _DualRingPainter(progress: progress),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${cycleDay == 0 ? '-' : cycleDay}',
                        style: AppTextStyles.display.copyWith(color: AppColors.primary, fontSize: 34)),
                    Text('Cycle Day', style: AppTextStyles.caption),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(AppColors.primary, 'Cycle Progress'),
              const SizedBox(width: 18),
              _legendDot(AppColors.accent, 'Days Left'),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _statChip(
                  icon: Icons.event_rounded,
                  label: 'Next Period',
                  value: '${prediction?['next_period_date'] ?? '-'}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statChip(
                  icon: Icons.hourglass_bottom_rounded,
                  label: 'Days Left',
                  value: '$daysUntil',
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _statChip({required IconData icon, required String label, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.h3.copyWith(fontSize: 14)),
          Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  /// Weekday streak row — mirrors the reference "goals achieved" weekday dots.
  Widget _buildWeekStreak() {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final today = DateTime.now().weekday % 7; // 0=Sun..6=Sat approx
    return SoftCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('This Week', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('Keep logging daily 🔥', style: AppTextStyles.caption),
              ],
            ),
          ),
          Row(
            children: List.generate(7, (i) {
              final active = i <= today;
              return Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Column(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: active ? const LinearGradient(colors: AppColors.brandGradient) : null,
                        color: active ? null : AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        days[i],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: active ? Colors.white : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return SoftCard(
      gradient: const LinearGradient(colors: AppColors.brandGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.22), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's Tip", style: AppTextStyles.label.copyWith(color: Colors.white.withOpacity(0.85))),
                const SizedBox(height: 4),
                Text(_tipOfDay, style: AppTextStyles.body.copyWith(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A self-contained card that shows today's water intake with quick +/- buttons.
/// Same data-loading & update logic as the original — only the visuals changed.
class WaterTrackerCard extends StatefulWidget {
  final int userId;
  const WaterTrackerCard({super.key, required this.userId});

  @override
  State<WaterTrackerCard> createState() => _WaterTrackerCardState();
}

class _WaterTrackerCardState extends State<WaterTrackerCard> {
  int _glasses = 0;
  int _goal = 8;
  bool _loading = true;
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final water = await ApiService.getTodayWater(widget.userId);
    if (!mounted) return;
    setState(() {
      _glasses = water?.glasses ?? 0;
      _goal = water?.goal ?? 8;
      _loading = false;
    });
  }

  Future<void> _change(int amount) async {
    if (_updating) return;
    setState(() {
      _updating = true;
      _glasses = (_glasses + amount).clamp(0, 999);
    });
    final water = await ApiService.addWater(widget.userId, amount);
    if (!mounted) return;
    setState(() {
      if (water != null) {
        _glasses = water.glasses;
        _goal = water.goal;
      }
      _updating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = _goal > 0 ? (_glasses / _goal).clamp(0.0, 1.0) : 0.0;
    final metGoal = _glasses >= _goal;

    return SoftCard(
      child: _loading
          ? const SizedBox(height: 60, child: Center(child: CircularProgressIndicator(color: AppColors.water)))
          : Row(
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: CustomPaint(
                    painter: _RingPainter(
                      progress: progress,
                      color: metGoal ? AppColors.success : AppColors.water,
                      backgroundColor: AppColors.waterLight,
                    ),
                    child: const Center(
                      child: Icon(Icons.water_drop_rounded, color: AppColors.water, size: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Water Intake', style: AppTextStyles.h3),
                      const SizedBox(height: 2),
                      Text('$_glasses / $_goal glasses today', style: AppTextStyles.bodyMuted),
                    ],
                  ),
                ),
                _circleIconButton(
                  icon: Icons.remove_rounded,
                  onTap: _glasses > 0 ? () => _change(-1) : null,
                ),
                const SizedBox(width: 8),
                _circleIconButton(
                  icon: Icons.add_rounded,
                  filled: true,
                  onTap: () => _change(1),
                ),
              ],
            ),
    );
  }

  Widget _circleIconButton({required IconData icon, VoidCallback? onTap, bool filled = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: filled ? AppColors.water : AppColors.waterLight,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: filled ? Colors.white : AppColors.water),
      ),
    );
  }
}

/// Simple circular progress ring painter used by the water tracker.
class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _RingPainter({required this.progress, required this.color, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 5;
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

/// Dual-tone thick ring used by the big Cycle Overview card,
/// styled after the reference "Activity" ring (two-tone circular progress).
class _DualRingPainter extends CustomPainter {
  final double progress;
  _DualRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 10;
    const strokeWidth = 14.0;

    final bgPaint = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    final outerPaint = Paint()
      ..shader = const LinearGradient(colors: AppColors.brandGradient).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      outerPaint,
    );

    final innerRadius = radius - strokeWidth - 6;
    final innerBg = Paint()
      ..color = AppColors.accent.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, innerRadius, innerBg);

    final innerFg = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      -math.pi / 2,
      2 * math.pi * (1 - progress),
      false,
      innerFg,
    );
  }

  @override
  bool shouldRepaint(covariant _DualRingPainter oldDelegate) => oldDelegate.progress != progress;
}
