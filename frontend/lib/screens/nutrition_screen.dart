import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/food_model.dart';
import '../services/api_service.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../theme/text_styles.dart';
import '../widgets/glass_card.dart';

class NutritionScreen extends StatefulWidget {
  final UserModel user;
  const NutritionScreen({super.key, required this.user});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final _descController = TextEditingController();
  String _mealType = 'Breakfast';
  List<FoodModel> _entries = [];
  bool _loading = true;

  final _suggestions = {
    'Breakfast': '🥗 Oats, fruits, nuts',
    'Fruits': '🍎 Apple, berries, papaya',
    'Vegetables': '🥦 Leafy greens, broccoli',
    'Protein': '🥜 Lentils, eggs, paneer',
  };

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  // ---- Same load/add logic as before ----
  Future<void> _loadEntries() async {
    if (widget.user.userId == null) return;
    final entries = await ApiService.getFoodEntries(widget.user.userId!);
    setState(() {
      _entries = entries;
      _loading = false;
    });
  }

  Future<void> _addEntry() async {
    if (widget.user.userId == null || _descController.text.trim().isEmpty) return;
    final entry = FoodModel(
      userId: widget.user.userId!,
      date: DateTime.now(),
      mealType: _mealType,
      description: _descController.text.trim(),
    );
    final success = await ApiService.addFoodEntry(entry);
    if (success) {
      _descController.clear();
      _loadEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Nutrition')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Healthy Suggestions', style: AppTextStyles.h3),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _suggestions.entries
                  .map((e) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(e.value, style: AppTextStyles.label.copyWith(color: const Color(0xFF16A34A))),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 22),
            Text('Log a Meal', style: AppTextStyles.h3),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: ['Breakfast', 'Lunch', 'Dinner', 'Snack'].map((m) {
                final selected = _mealType == m;
                return ChoiceChip(
                  label: Text(m),
                  selected: selected,
                  selectedColor: AppColors.primary,
                  labelStyle: AppTextStyles.label.copyWith(color: selected ? Colors.white : AppColors.textSecondary),
                  onSelected: (_) => setState(() => _mealType = m),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      boxShadow: [BoxShadow(color: AppColors.shadowSoft, blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: TextField(
                      controller: _descController,
                      style: AppTextStyles.body,
                      decoration: InputDecoration(
                        hintText: 'What did you eat?',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: _addEntry,
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(gradient: LinearGradient(colors: AppColors.brandGradient), shape: BoxShape.circle),
                    child: const Icon(Icons.add_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text('History', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : _entries.isEmpty
                      ? Center(child: Text('No meals logged yet.', style: AppTextStyles.bodyMuted))
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: _entries.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final e = _entries[index];
                            return SoftCard(
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: AppColors.success.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                                    child: const Icon(Icons.restaurant_rounded, color: Color(0xFF16A34A), size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(e.description ?? '', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 2),
                                        Text('${e.mealType} • ${e.date.toLocal().toString().split(' ')[0]}',
                                            style: AppTextStyles.caption),
                                      ],
                                    ),
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
