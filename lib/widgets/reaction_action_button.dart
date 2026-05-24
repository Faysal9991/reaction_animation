import 'package:flutter/material.dart';

class ReactionActionButton extends StatefulWidget {
  const ReactionActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    required this.disabled,
    this.width = 142,
    this.height = 62,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  final bool disabled;
  final double width;
  final double height;

  @override
  State<ReactionActionButton> createState() => _ReactionActionButtonState();
}

class _ReactionActionButtonState extends State<ReactionActionButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.disabled
          ? null
          : (_) {
              setState(() => pressed = true);
            },
      onTapCancel: () {
        setState(() => pressed = false);
      },
      onTapUp: widget.disabled
          ? null
          : (_) {
              setState(() => pressed = false);
              widget.onTap();
            },
      child: AnimatedScale(
        scale: pressed ? 0.92 : 1,
        duration: const Duration(milliseconds: 120),
        child: Opacity(
          opacity: widget.disabled ? 0.35 : 1,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.color.withValues(alpha: 0.24),
                  widget.color.withValues(alpha: 0.08),
                ],
              ),
              border: Border.all(color: widget.color.withValues(alpha: 0.50)),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.25),
                  blurRadius: 25,
                  spreadRadius: 1,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: widget.color, size: 30),
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
