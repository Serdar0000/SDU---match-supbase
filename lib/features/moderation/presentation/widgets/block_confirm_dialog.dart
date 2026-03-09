import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../bloc/moderation_bloc.dart';

class BlockConfirmDialog extends StatelessWidget {
  final String blockedUserName;
  final String blockedUserId;
  final VoidCallback onSuccess;

  const BlockConfirmDialog({
    super.key,
    required this.blockedUserName,
    required this.blockedUserId,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final l = S.of(context)!;
    final theme = Theme.of(context);

    return BlocListener<ModerationBloc, ModerationState>(
      listener: (context, state) {
        state.maybeWhen(
          success: (message, blockedIds) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.userBlocked)),
            );
            Navigator.pop(context);
            onSuccess();
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $message')),
            );
          },
          orElse: () {},
        );
      },
      child: AlertDialog(
        title: Text(l.block),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Block ',
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: blockedUserName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '?',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l.blockConfirm,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          BlocBuilder<ModerationBloc, ModerationState>(
            builder: (context, state) {
              final isLoading = state.maybeWhen(
                loading: () => true,
                orElse: () => false,
              );

              return TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: Text(l.cancel),
              );
            },
          ),
          BlocBuilder<ModerationBloc, ModerationState>(
            builder: (context, state) {
              final isLoading = state.maybeWhen(
                loading: () => true,
                orElse: () => false,
              );

              return ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        context.read<ModerationBloc>().add(
                              ModerationEvent.blockUserRequested(
                                blockedId: blockedUserId,
                              ),
                            );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text(l.block),
              );
            },
          ),
        ],
      ),
    );
  }
}
