// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../domain/entities/user_profile.dart';

class MatchOverlay extends StatefulWidget {
  final UserProfile matchedUser;
  final UserProfile? currentUser;
  final VoidCallback onKeepSwiping;
  final VoidCallback onSendMessage;

  const MatchOverlay({
    Key? key,
    required this.matchedUser,
    required this.currentUser,
    required this.onKeepSwiping,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  State<MatchOverlay> createState() => _MatchOverlayState();
}

class _MatchOverlayState extends State<MatchOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.85),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background particles or effects could go here

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: const Text(
                  "It's a Match!",
                  style: TextStyle(
                    fontFamily: 'Love', // Assuming a custom font or use generic script
                    fontSize: 48,
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProfileImage(widget.currentUser?.imageUrl),
                  const SizedBox(width: 20),
                  const Icon(Icons.favorite, color: Colors.pink, size: 50),
                  const SizedBox(width: 20),
                  _buildProfileImage(widget.matchedUser.imageUrl),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "You and ${widget.matchedUser.name} like each other!",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 60),

              // Send Message Button
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: widget.onSendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text("Send Message", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),

              // Keep Swiping Button
              TextButton(
                onPressed: widget.onKeepSwiping,
                child: const Text(
                  "Keep Swiping",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(String? url) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
           BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 5))
        ],
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[800],
        backgroundImage: (url != null && url.isNotEmpty) 
            ? NetworkImage(url) 
            : null,
        child: (url == null || url.isEmpty) 
            ? const Icon(Icons.person, color: Colors.white, size: 40) 
            : null,
      ),
    );
  }
}
