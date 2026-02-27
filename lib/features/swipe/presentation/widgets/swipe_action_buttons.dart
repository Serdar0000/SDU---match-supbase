import 'package:flutter/material.dart';

/// Кнопки действий для свайпа: Pass (X), Super Like (⭐), Like (❤️)
class SwipeActionButtons extends StatelessWidget {
  final VoidCallback onPass;
  final VoidCallback onSuperLike;
  final VoidCallback onLike;
  final bool isEnabled;

  const SwipeActionButtons({
    super.key,
    required this.onPass,
    required this.onSuperLike,
    required this.onLike,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Pass Button (X)
          _SwipeButton(
            icon: Icons.close,
            color: Colors.red,
            size: 56,
            iconSize: 32,
            onPressed: isEnabled ? onPass : null,
            tooltip: 'Pass',
          ),
          
          // Super Like Button (⭐)
          _SwipeButton(
            icon: Icons.star,
            color: const Color(0xFFFFD700), // Золотой цвет
            size: 72, // Немного больше остальных
            iconSize: 40,
            onPressed: isEnabled ? onSuperLike : null,
            tooltip: 'Super Like',
          ),
          
          // Like Button (❤️)
          _SwipeButton(
            icon: Icons.favorite,
            color: Colors.green,
            size: 56,
            iconSize: 32,
            onPressed: isEnabled ? onLike : null,
            tooltip: 'Like',
          ),
        ],
      ),
    );
  }
}

class _SwipeButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final VoidCallback? onPressed;
  final String tooltip;

  const _SwipeButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.iconSize,
    this.onPressed,
    this.tooltip = '',
  });

  @override
  State<_SwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<_SwipeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;

    return Tooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onTapDown: isEnabled ? _handleTapDown : null,
        onTapUp: isEnabled ? _handleTapUp : null,
        onTapCancel: isEnabled ? _handleTapCancel : null,
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotateAnimation.value,
                child: child,
              ),
            );
          },
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: isEnabled ? Colors.white : Colors.grey.shade300,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isEnabled
                      ? widget.color.withOpacity(0.3)
                      : Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: isEnabled ? widget.color : Colors.grey.shade400,
                width: 2,
              ),
            ),
            child: Icon(
              widget.icon,
              color: isEnabled ? widget.color : Colors.grey.shade400,
              size: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
