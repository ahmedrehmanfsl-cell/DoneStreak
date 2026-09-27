import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/commitment.dart';

class MemoryReelScreen extends StatelessWidget {
  final List<Commitment> commitments;
  const MemoryReelScreen({super.key, required this.commitments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0714),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Memory reel'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: commitments.length,
        itemBuilder: (context, index) {
          final c = commitments[index];
          final entries = c.proofsByDate.entries.toList()
            ..sort((a, b) => b.key.compareTo(a.key));

          return Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(c.emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      c.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (entries.isEmpty)
                  Text(
                    'No proofs captured yet',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: entries.length,
                    itemBuilder: (context, i) {
                      final entry = entries[i];
                      final file = File(entry.value);
                      final label =
                          DateFormat('MMM d').format(DateTime.parse(entry.key));
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            file.existsSync()
                                ? Image.file(file, fit: BoxFit.cover)
                                : Container(color: Colors.white10),
                            Positioned(
                              bottom: 4,
                              left: 4,
                              child: Text(
                                label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  shadows: [
                                    Shadow(blurRadius: 4, color: Colors.black)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
