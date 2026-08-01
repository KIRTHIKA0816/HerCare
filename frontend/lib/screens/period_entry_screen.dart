import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/period_model.dart';
import '../services/api_service.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../theme/text_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/glass_card.dart';

class PeriodEntryScreen extends StatefulWidget {
  final UserModel user;
  const PeriodEntryScreen({super.key, required this.user});

  @override
  State<PeriodEntryScreen> createState() => _PeriodEntryScreenState();
}

class _PeriodEntryScreenState extends State<PeriodEntryScreen> {
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  String _flowLevel = 'Medium';
  double _cycleLength = 28;
  bool _isLoading = false;

  // ---- Same date-picking/save logic as before ----
  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (widget.user.userId == null) return;
    setState(() => _isLoading = true);
    final period = PeriodModel(
      userId: widget.user.userId!,
      startDate: _startDate,
      endDate: _endDate,
      cycleLength: _cycleLength.round(),
      flowLevel: _flowLevel,
    );
    final success = await ApiService.addPeriod(period);
    setState(() => _isLoading = false);
    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Track Period')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DateTile(
              label: 'Start Date',
              value: _startDate.toLocal().toString().split(' ')[0],
              onTap: () => _pickDate(isStart: true),
            ),
            const SizedBox(height: 12),
            _DateTile(
              label: 'End Date (optional)',
              value: _endDate?.toLocal().toString().split(' ')[0] ?? 'Not set',
              onTap: () => _pickDate(isStart: false),
            ),
            const SizedBox(height: 22),
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Flow Intensity', style: AppTextStyles.h3),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['Light', 'Medium', 'Heavy'].map((f) {
                      final selected = _flowLevel == f;
                      return ChoiceChip(
                        label: Text(f),
                        selected: selected,
                        selectedColor: AppColors.primary,
                        labelStyle: AppTextStyles.label.copyWith(color: selected ? Colors.white : AppColors.textSecondary),
                        onSelected: (_) => setState(() => _flowLevel = f),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text('Average Cycle Length: ${_cycleLength.round()} days',
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                  Slider(
                    value: _cycleLength,
                    min: 20,
                    max: 45,
                    divisions: 25,
                    label: '${_cycleLength.round()} days',
                    onChanged: (val) => setState(() => _cycleLength = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(text: 'Save Period', isLoading: _isLoading, onPressed: _save),
          ],
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _DateTile({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [BoxShadow(color: AppColors.shadowSoft, blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
