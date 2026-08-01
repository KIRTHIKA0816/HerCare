import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../theme/text_styles.dart';
import '../widgets/glass_card.dart';

class NotesScreen extends StatefulWidget {
  final UserModel user;
  const NotesScreen({super.key, required this.user});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<String> _notes = [];
  final _controller = TextEditingController();

  // ---- Same note-adding logic as before ----
  void _addNote() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _notes.insert(0, _controller.text.trim());
      _controller.clear();
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text('Notes', style: AppTextStyles.h1),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        boxShadow: [BoxShadow(color: AppColors.shadowSoft, blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: TextField(
                        controller: _controller,
                        style: AppTextStyles.body,
                        decoration: InputDecoration(
                          hintText: 'Write a note...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: _addNote,
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(gradient: LinearGradient(colors: AppColors.brandGradient), shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _notes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.note_alt_outlined, size: 56, color: AppColors.textMuted.withOpacity(0.5)),
                          const SizedBox(height: 12),
                          Text('No notes yet.', style: AppTextStyles.bodyMuted),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                      itemCount: _notes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => SoftCard(
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.4), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.note_rounded, color: AppColors.primaryDark, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(_notes[index], style: AppTextStyles.body)),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
