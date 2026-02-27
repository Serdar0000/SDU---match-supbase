import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_chat_service.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../swipe/domain/entities/user_profile.dart';
import '../../bloc/chat_bloc.dart';
import '../widgets/chat_bubble.dart';

class ChatPage extends StatelessWidget {
  final String matchId;
  final UserProfile? otherProfile;

  const ChatPage({
    super.key,
    required this.matchId,
    this.otherProfile,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(chatService: SupabaseChatService())
        ..add(ChatEvent.started(matchId)),
      child: _ChatView(matchId: matchId, otherProfile: otherProfile),
    );
  }
}


class _ChatView extends StatefulWidget {
  final String matchId;
  final UserProfile? otherProfile;

  const _ChatView({required this.matchId, this.otherProfile});

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String _currentUid = Supabase.instance.client.auth.currentUser?.id ?? '';

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    context.read<ChatBloc>().add(ChatEvent.messageSent(text));
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.otherProfile;
    final avatarUrl = (profile?.imageUrl.isNotEmpty ?? false)
        ? CloudinaryService.getOptimizedUrl(profile!.imageUrl,
            width: 80, height: 80)
        : '';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
              backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.2),
              child: avatarUrl.isEmpty
                  ? Text(
                      profile?.name.isNotEmpty == true
                          ? profile!.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?.name ?? 'ProfileName',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (profile?.faculty.isNotEmpty == true)
                  Text(
                    profile!.faculty,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded) {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _scrollToBottom());
                }
                if (state is ChatError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return switch (state) {
                  ChatInitial() || ChatLoading() =>
                    const Center(child: CircularProgressIndicator()),
                  ChatError(:final message) => Center(
                      child: Text(
                        'Ошибка: $message',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ChatLoaded(:final messages) => messages.isEmpty
                      ? _buildEmptyChat(profile, context)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final msg = messages[index];
                            final isMe = msg.senderId == _currentUid;

                            bool showDateDivider = false;
                            if (index == 0) {
                              showDateDivider = true;
                            } else {
                              final prev = messages[index - 1];
                              final prevDay = DateTime(prev.timestamp.year,
                                  prev.timestamp.month, prev.timestamp.day);
                              final curDay = DateTime(msg.timestamp.year,
                                  msg.timestamp.month, msg.timestamp.day);
                              if (curDay.isAfter(prevDay)) {
                                showDateDivider = true;
                              }
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (showDateDivider)
                                  DateDivider(date: msg.timestamp),
                                ChatBubble(message: msg, isMe: isMe),
                              ],
                            );
                          },
                        ),
                };
              },
            ),
          ),

          _InputBar(
            controller: _textController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChat(UserProfile? profile, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('SDU MATCH', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'Начните чат с ${profile?.name ?? 'ним'}!',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}


class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSending = context.select<ChatBloc, bool>(
      (bloc) =>
          bloc.state is ChatLoaded && (bloc.state as ChatLoaded).isSending,
    );
    final isDisabled = isSending;

    return Material(
      elevation: 4,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          color: isDark ? AppColors.darkSurface : Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: !isDisabled,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Сообщение...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkCard
                        : Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                  maxLines: 4,
                  minLines: 1,
                  onSubmitted: (_) => onSend(),
                ),
              ),
              const SizedBox(width: 8),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (_, value, __) {
                  final hasText = value.text.trim().isNotEmpty;
                  return isSending
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          onPressed: (hasText && !isDisabled) ? onSend : null,
                          icon: Icon(
                            Icons.send_rounded,
                            color: (hasText && !isDisabled)
                                ? AppColors.primaryBlue
                                : Colors.grey.shade400,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: (hasText && !isDisabled)
                                ? AppColors.primaryBlue
                                    .withValues(alpha: 0.1)
                                : null,
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
