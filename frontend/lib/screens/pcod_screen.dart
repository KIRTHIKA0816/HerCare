import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/pcod_model.dart';
import '../services/api_service.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../theme/text_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/glass_card.dart';

class PcodScreen extends StatefulWidget {
  final UserModel user;
  const PcodScreen({super.key, required this.user});

  @override
  State<PcodScreen> createState() => _PcodScreenState();
}

class _PcodScreenState extends State<PcodScreen> {
  final _weightChangeController = TextEditingController();
  final _sleepController = TextEditingController();
  double _stressLevel = 3;
  bool _exerciseDone = false;
  double _waterIntake = 6;
  bool _isLoading = false;
  Map<String, dynamic>? _summary;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  // ---- Same load/save logic as before ----
  Future<void> _loadSummary() async {
    if (widget.user.userId == null) return;
    final summary = await ApiService.getPcodSummary(widget.user.userId!);
    if (mounted) setState(() => _summary = summary);
  }

  Future<void> _save() async {
    if (widget.user.userId == null) return;
    setState(() => _isLoading = true);
    final entry = PcodModel(
      userId: widget.user.userId!,
      date: DateTime.now(),
      weightChange: double.tryParse(_weightChangeController.text.trim()),
      sleepHours: double.tryParse(_sleepController.text.trim()),
      stressLevel: _stressLevel.round(),
      exerciseDone: _exerciseDone,
      waterIntake: _waterIntake.round(),
    );
    final success = await ApiService.addPcodEntry(entry);
    setState(() => _isLoading = false);
    if (success && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('PCOD entry saved!'), backgroundColor: AppColors.success));
      _loadSummary();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('PCOD Health')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_summary != null) _buildSummaryCard(),
            const SizedBox(height: 20),
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Log Today', style: AppTextStyles.h3),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _weightChangeController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: const InputDecoration(labelText: 'Weight Change (kg)'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _sleepController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Sleep Hours'),
                  ),
                  const SizedBox(height: 16),
                  Text('Stress Level: ${_stressLevel.round()} / 5', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                  Slider(
                    value: _stressLevel,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (val) => setState(() => _stressLevel = val),
                  ),
                  Text('Water Intake: ${_waterIntake.round()} glasses', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                  Slider(
                    value: _waterIntake,
                    min: 0,
                    max: 15,
                    divisions: 15,
                    onChanged: (val) => setState(() => _waterIntake = val),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Exercise Done Today', style: AppTextStyles.body),
                    value: _exerciseDone,
                    onChanged: (val) => setState(() => _exerciseDone = val),
                  ),
                  const SizedBox(height: 8),
                  CustomButton(text: 'Save Entry', isLoading: _isLoading, onPressed: _save),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final avgSleep = (_summary!['avg_sleep_hours'] as num?)?.toDouble();
    final avgStress = (_summary!['avg_stress_level'] as num?)?.toDouble();
    final avgWater = (_summary!['avg_water_intake'] as num?)?.toDouble();
    final exerciseDays = _summary!['exercise_days'];

    return SoftCard(
      gradient: const LinearGradient(colors: AppColors.softGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights_rounded, color: AppColors.primary, size: 18),
              const SizedBox(width: 6),
              Text('Last 30 Days', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 10),
          Text('Avg. Sleep: ${avgSleep?.toStringAsFixed(1) ?? '-'} hrs', style: AppTextStyles.bodyMuted),
          Text('Avg. Stress: ${avgStress?.toStringAsFixed(1) ?? '-'} / 5', style: AppTextStyles.bodyMuted),
          Text('Avg. Water Intake: ${avgWater?.toStringAsFixed(1) ?? '-'} glasses', style: AppTextStyles.bodyMuted),
          Text('Exercise Days: ${exerciseDays ?? 0}', style: AppTextStyles.bodyMuted),
        ],
      ),
    );
  }
}
