import 'package:flutter/material.dart';

import '../effects/flying_reaction_overlay.dart';
import '../widgets/person_card.dart';
import '../widgets/reaction_bar.dart';

class FlyingReactionScreen extends StatefulWidget {
  const FlyingReactionScreen({super.key});

  @override
  State<FlyingReactionScreen> createState() => _FlyingReactionScreenState();
}

class _FlyingReactionScreenState extends State<FlyingReactionScreen>
    with TickerProviderStateMixin {
  final persons = const [
    'https://i.pravatar.cc/500?img=11',
    'https://i.pravatar.cc/500?img=12',
    'https://i.pravatar.cc/500?img=13',
    'https://i.pravatar.cc/500?img=14',
  ];

  final Set<int> selectedIndexes = {0};
  final GlobalKey likeKey = GlobalKey();
  final GlobalKey loveKey = GlobalKey();

  late final List<GlobalKey> imageKeys;

  @override
  void initState() {
    super.initState();
    imageKeys = List.generate(persons.length, (_) => GlobalKey());
  }

  void _togglePersonSelection(int index) {
    setState(() {
      selectedIndexes.contains(index)
          ? selectedIndexes.remove(index)
          : selectedIndexes.add(index);
    });
  }

  void _flyReactionToSelected({
    required GlobalKey fromKey,
    required IconData icon,
    required Color color,
  }) {
    var delay = 0;

    for (final index in selectedIndexes) {
      Future.delayed(Duration(milliseconds: delay), () {
        if (!mounted) return;

        FlyingReactionOverlay.show(
          context: context,
          vsync: this,
          fromKey: fromKey,
          toKey: imageKeys[index],
          icon: icon,
          color: color,
        );
      });

      delay += 120;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b0b10),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff111118),
        title: const Text(
          'Flying Reaction Animation',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: persons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          childAspectRatio: 0.82,
        ),
        itemBuilder: (_, index) {
          final isSelected = selectedIndexes.contains(index);

          return PersonCard(
            imageUrl: persons[index],
            imageKey: imageKeys[index],
            label: 'Person ${index + 1}',
            isSelected: isSelected,
            onTap: () => _togglePersonSelection(index),
          );
        },
      ),
      bottomNavigationBar: ReactionBar(
        likeKey: likeKey,
        loveKey: loveKey,
        disabled: selectedIndexes.isEmpty,
        onLike: () {
          _flyReactionToSelected(
            fromKey: likeKey,
            icon: Icons.thumb_up_rounded,
            color: Colors.blueAccent,
          );
        },
        onLove: () {
          _flyReactionToSelected(
            fromKey: loveKey,
            icon: Icons.favorite_rounded,
            color: Colors.redAccent,
          );
        },
      ),
    );
  }
}
