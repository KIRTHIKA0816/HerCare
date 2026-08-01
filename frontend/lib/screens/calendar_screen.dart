import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/period_model.dart';
import '../services/api_service.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../theme/text_styles.dart';
import '../widgets/glass_card.dart';
import 'period_entry_screen.dart';

class CalendarScreen extends StatefulWidget {
  final UserModel user;
  const CalendarScreen({super.key, required this.user});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<PeriodModel> _periods = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPeriods();
  }

  // ---- Same data-loading logic as before ----
  Future<void> _loadPeriods() async {
    if (widget.user.userId == null) return;
    final periods = await ApiService.getPeriods(widget.user.userId!);
    setState(() {
      _periods = periods;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : _periods.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
                          itemCount: _periods.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final p = _periods[index];
                            return _PeriodCard(period: p);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: AppColors.heroGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text('Cycle Calendar', style: AppTextStyles.h1.copyWith(color: Colors.white)),
          ),
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PeriodEntryScreen(user: widget.user)),
              );
              _loadPeriods();
            },
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.22), shape: BoxShape.circle),
              child: const Icon(Icons.add_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_month_rounded, size: 56, color: AppColors.textMuted.withOpacity(0.5)),
            const SizedBox(height: 12),
            Text('No period logs yet.', style: AppTextStyles.h3),
            const SizedBox(height: 6),
            Text('Tap + to add your first entry.', style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _PeriodCard extends StatelessWidget {
  final PeriodModel period;
  const _PeriodCard({required this.period});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.brandGradient),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Started: ${period.startDate.toLocal().toString().split(' ')[0]}',
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(
                  'Flow: ${period.flowLevel}${period.endDate != null ? ' • Ended: ${period.endDate!.toLocal().toString().split(' ')[0]}' : ''}',
                  style: AppTextStyles.bodyMuted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
