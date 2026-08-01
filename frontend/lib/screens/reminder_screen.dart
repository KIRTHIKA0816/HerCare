import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/reminder_model.dart';
import '../services/api_service.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../theme/text_styles.dart';
import '../widgets/glass_card.dart';

class ReminderScreen extends StatefulWidget {
  final UserModel user;
  const ReminderScreen({super.key, required this.user});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<ReminderModel> _reminders = [];
  bool _loading = true;
  String _type = 'Period';
  DateTime _date = DateTime.now();

  final _icons = {
    'Period': Icons.water_drop_rounded,
    'Water': Icons.local_drink_rounded,
    'Exercise': Icons.fitness_center_rounded,
    'Medicine': Icons.medication_rounded,
  };

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  // ---- Same load/add/toggle/delete logic as before ----
  Future<void> _loadReminders() async {
    if (widget.user.userId == null) return;
    final reminders = await ApiService.getReminders(widget.user.userId!);
    setState(() {
      _reminders = reminders;
      _loading = false;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _addReminder() async {
    if (widget.user.userId == null) return;
    final reminder = ReminderModel(
      userId: widget.user.userId!,
      reminderType: _type,
      reminderDate: _date,
    );
    final success = await ApiService.addReminder(reminder);
    if (success) _loadReminders();
  }

  Future<void> _toggleStatus(ReminderModel r) async {
    final newStatus = r.status == 'Completed' ? 'Pending' : 'Completed';
    await ApiService.updateReminderStatus(r.reminderId!, newStatus);
    _loadReminders();
  }

  Future<void> _delete(ReminderModel r) async {
    await ApiService.deleteReminder(r.reminderId!);
    _loadReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Reminders')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New Reminder', style: AppTextStyles.h3),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _icons.keys.map((t) {
                final selected = _type == t;
                return ChoiceChip(
                  label: Text(t),
                  selected: selected,
                  selectedColor: AppColors.primary,
                  labelStyle: AppTextStyles.label.copyWith(color: selected ? Colors.white : AppColors.textSecondary),
                  onSelected: (_) => setState(() => _type = t),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        boxShadow: [BoxShadow(color: AppColors.shadowSoft, blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text('Date: ${_date.toLocal().toString().split(' ')[0]}', style: AppTextStyles.body)),
                          const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: _addReminder,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: AppColors.brandGradient),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Center(child: Text('Add', style: AppTextStyles.button)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Your Reminders', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : _reminders.isEmpty
                      ? Center(child: Text('No reminders set.', style: AppTextStyles.bodyMuted))
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: _reminders.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final r = _reminders[index];
                            final isDone = r.status == 'Completed';
                            return SoftCard(
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: AppColors.brandGradient),
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: Icon(_icons[r.reminderType] ?? Icons.notifications_rounded, color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          r.reminderType,
                                          style: AppTextStyles.body.copyWith(
                                            fontWeight: FontWeight.w600,
                                            decoration: isDone ? TextDecoration.lineThrough : null,
                                            color: isDone ? AppColors.textMuted : AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text('${r.reminderDate.toLocal().toString().split(' ')[0]} • ${r.status}',
                                            style: AppTextStyles.caption),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(isDone ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                                        color: AppColors.success),
                                    onPressed: () => _toggleStatus(r),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                                    onPressed: () => _delete(r),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
