import 'package:flutter/material.dart';
import '../models/commitment.dart';
import 'streak_orb.dart';

class CommitmentCard extends StatelessWidget {
  final Commitment commitment;
  final bool doneToday;
  final VoidCallback onCapture;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CommitmentCard({
    super.key,
    required this.commitment,
    required this.doneToday,
    required this.onCapture,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white70),
              color: const Color(0xFF1E1A29),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit?.call();
                } else if (value == 'delete') {
                  onDelete?.call();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, color: Colors.white70, size: 20),
                      SizedBox(width: 10),
                      Text('Edit', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                      SizedBox(width: 10),
                      Text('Delete', style: TextStyle(color: Colors.redAccent)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(commitment.emoji, style: const TextStyle(fontSize: 34)),
              const SizedBox(height: 8),
              Text(
                commitment.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              StreakOrb(streak: commitment.currentStreak, size: 140),
              const SizedBox(height: 18),
              Text(
                '${commitment.currentStreak} day streak · best ${commitment.bestStreak}',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 13),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: doneToday ? null : onCapture,
                  icon: Icon(doneToday ? Icons.check_circle : Icons.camera_alt),
                  label: Text(doneToday ? "Today's proof sent" : 'Capture proof'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        doneToday ? Colors.white.withValues(alpha: 0.12) : Colors.white,
                    foregroundColor: doneToday ? Colors.white70 : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
