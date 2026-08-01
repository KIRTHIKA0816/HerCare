import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/symptom_model.dart';
import '../services/api_service.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../theme/text_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/glass_card.dart';

class SymptomScreen extends StatefulWidget {
  final UserModel user;
  const SymptomScreen({super.key, required this.user});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  double _painLevel = 0;
  String _mood = 'Normal';
  bool _acne = false;
  bool _hairFall = false;
  bool _cramps = false;
  final _notesController = TextEditingController();
  bool _isLoading = false;

  final _moods = {
    'Happy': '😊',
    'Normal': '😐',
    'Sad': '😔',
    'Angry': '😡',
  };

  // ---- Same save logic as before ----
  Future<void> _save() async {
    if (widget.user.userId == null) return;
    setState(() => _isLoading = true);
    final symptom = SymptomModel(
      userId: widget.user.userId!,
      date: DateTime.now(),
      painLevel: _painLevel.round(),
      mood: _mood,
      acne: _acne,
      hairFall: _hairFall,
      cramps: _cramps,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );
    final success = await ApiService.addSymptom(symptom);
    setState(() => _isLoading = false);
    if (success && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Symptoms saved!'), backgroundColor: AppColors.success));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Log Symptoms')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pain Level', style: AppTextStyles.h3),
                  Slider(
                    value: _painLevel,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: _painLevel.round().toString(),
                    onChanged: (val) => setState(() => _painLevel = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mood', style: AppTextStyles.h3),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: _moods.entries.map((entry) {
                      final selected = _mood == entry.key;
                      return ChoiceChip(
                        label: Text('${entry.value} ${entry.key}'),
                        selected: selected,
                        selectedColor: AppColors.primary,
                        labelStyle: AppTextStyles.label.copyWith(color: selected ? Colors.white : AppColors.textSecondary),
                        onSelected: (_) => setState(() => _mood = entry.key),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SoftCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
                    child: Align(alignment: Alignment.centerLeft, child: Text('Symptoms', style: AppTextStyles.h3)),
                  ),
                  CheckboxListTile(
                    title: Text('Cramps', style: AppTextStyles.body),
                    value: _cramps,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _cramps = val ?? false),
                  ),
                  CheckboxListTile(
                    title: Text('Acne', style: AppTextStyles.body),
                    value: _acne,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _acne = val ?? false),
                  ),
                  CheckboxListTile(
                    title: Text('Hair Fall', style: AppTextStyles.body),
                    value: _hairFall,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _hairFall = val ?? false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [BoxShadow(color: AppColors.shadowSoft, blurRadius: 14, offset: const Offset(0, 6))],
              ),
              child: TextField(
                controller: _notesController,
                maxLines: 3,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: 'Write your experience...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.lg), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(height: 22),
            CustomButton(text: 'Save', isLoading: _isLoading, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
