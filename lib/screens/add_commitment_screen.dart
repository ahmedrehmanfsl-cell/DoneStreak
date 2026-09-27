import 'package:flutter/material.dart';
import '../models/commitment.dart';

const _emojiChoices = [
  '🏋️', '📚', '🥗', '🧘', '💧', '🏃', '✍️', '🎯', '🛌', '🚭', '🎸', '🧹'
];

class AddCommitmentScreen extends StatefulWidget {
  final Commitment? existing;

  const AddCommitmentScreen({super.key, this.existing});

  @override
  State<AddCommitmentScreen> createState() => _AddCommitmentScreenState();
}

class _AddCommitmentScreenState extends State<AddCommitmentScreen> {
  late final TextEditingController _controller;
  late String _selectedEmoji;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existing?.title ?? '');
    _selectedEmoji = widget.existing?.emoji ?? _emojiChoices.first;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    return Scaffold(
      backgroundColor: const Color(0xFF0B0714),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(isEditing ? 'Edit commitment' : 'New commitment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: const InputDecoration(
                hintText: 'e.g. Gym, Read 10 pages, No junk food',
                hintStyle: TextStyle(color: Colors.white38),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Pick an icon', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _emojiChoices.map((e) {
                final selected = e == _selectedEmoji;
                return GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = e),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.white.withValues(alpha: 0.18)
                          : Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? Colors.white : Colors.transparent,
                      ),
                    ),
                    child: Text(e, style: const TextStyle(fontSize: 24)),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final title = _controller.text.trim();
                  if (title.isEmpty) return;
                  final existing = widget.existing;
                  Navigator.of(context).pop(
                    Commitment(
                      id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
                      title: title,
                      emoji: _selectedEmoji,
                      currentStreak: existing?.currentStreak ?? 0,
                      bestStreak: existing?.bestStreak ?? 0,
                      lastProofDate: existing?.lastProofDate,
                      proofsByDate: existing != null
                          ? Map<String, String>.from(existing.proofsByDate)
                          : {},
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(isEditing ? 'Save changes' : 'Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
