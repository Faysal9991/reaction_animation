import 'package:flutter/material.dart';

import 'reaction_action_button.dart';

class ReactionBar extends StatelessWidget {
  const ReactionBar({
    super.key,
    required this.likeKey,
    required this.loveKey,
    required this.disabled,
    required this.onLike,
    required this.onLove,
  });

  final GlobalKey likeKey;
  final GlobalKey loveKey;
  final bool disabled;
  final VoidCallback onLike;
  final VoidCallback onLove;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xff111118),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ReactionActionButton(
            key: likeKey,
            icon: Icons.thumb_up_rounded,
            color: Colors.blueAccent,
            label: 'Like',
            disabled: disabled,
            onTap: onLike,
          ),
          ReactionActionButton(
            key: loveKey,
            icon: Icons.favorite_rounded,
            color: Colors.redAccent,
            label: 'Love',
            disabled: disabled,
            onTap: onLove,
          ),
        ],
      ),
    );
  }
}
