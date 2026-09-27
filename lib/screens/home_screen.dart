import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import '../models/commitment.dart';
import '../services/storage_service.dart';
import '../widgets/commitment_card.dart';
import 'memory_reel_screen.dart';
import 'add_commitment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = StorageService();
  final _picker = ImagePicker();
  final _pageController = PageController(viewportFraction: 0.86);

  List<Commitment> _commitments = [];
  bool _loading = true;

  String get _todayKey => DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await _storage.load();
    setState(() {
      _commitments = list;
      _loading = false;
    });
  }

  bool _doneToday(Commitment c) => c.lastProofDate == _todayKey;

  Future<void> _captureProof(Commitment c) async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (image == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final proofDir = Directory('${dir.path}/proofs/${c.id}');
    if (!await proofDir.exists()) {
      await proofDir.create(recursive: true);
    }
    final savedPath = '${proofDir.path}/$_todayKey.jpg';
    await File(image.path).copy(savedPath);

    setState(() {
      final yesterday = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(const Duration(days: 1)));
      final continuingStreak = c.lastProofDate == yesterday;

      c.currentStreak = continuingStreak ? c.currentStreak + 1 : 1;
      c.bestStreak =
          c.currentStreak > c.bestStreak ? c.currentStreak : c.bestStreak;
      c.lastProofDate = _todayKey;
      c.proofsByDate[_todayKey] = savedPath;
    });

    await _storage.save(_commitments);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Proof sent · ${c.currentStreak}-day streak 🔥'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
        ),
      );
    }
  }

  Future<void> _addCommitment() async {
    final created = await Navigator.of(context).push<Commitment>(
      MaterialPageRoute(builder: (_) => const AddCommitmentScreen()),
    );
    if (created != null) {
      setState(() => _commitments.add(created));
      await _storage.save(_commitments);
    }
  }

  Future<void> _editCommitment(Commitment c) async {
    final updated = await Navigator.of(context).push<Commitment>(
      MaterialPageRoute(
        builder: (_) => AddCommitmentScreen(existing: c),
      ),
    );
    if (updated != null) {
      setState(() {
        final index = _commitments.indexWhere((item) => item.id == updated.id);
        if (index != -1) {
          _commitments[index] = updated;
        }
      });
      await _storage.save(_commitments);
    }
  }

  Future<void> _deleteCommitment(Commitment c) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1A29),
        title: const Text(
          'Delete commitment',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Delete '${c.title}'? This removes its streak and photos too.",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _commitments.removeWhere((item) => item.id == c.id);
      });
      await _storage.save(_commitments);

      final dir = await getApplicationDocumentsDirectory();
      final proofDir = Directory('${dir.path}/proofs/${c.id}');
      if (await proofDir.exists()) {
        await proofDir.delete(recursive: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0714),
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white54))
            : Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'DoneStreak',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.grid_view_rounded,
                                  color: Colors.white70),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => MemoryReelScreen(
                                      commitments: _commitments,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  color: Colors.white70),
                              onPressed: _addCommitment,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _commitments.isEmpty
                        ? _EmptyState(onAdd: _addCommitment)
                        : PageView.builder(
                            controller: _pageController,
                            itemCount: _commitments.length,
                            itemBuilder: (context, index) {
                              final c = _commitments[index];
                              return CommitmentCard(
                                commitment: c,
                                doneToday: _doneToday(c),
                                onCapture: () => _captureProof(c),
                                onEdit: () => _editCommitment(c),
                                onDelete: () => _deleteCommitment(c),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('No commitments yet',
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onAdd,
            child: const Text('Add your first one'),
          ),
        ],
      ),
    );
  }
}
