import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import 'block_confirm_dialog.dart';
import 'report_bottom_sheet.dart';

class UserActionsMenu extends StatelessWidget {
  final String userId;
  final String userName;
  final VoidCallback onSuccess;

  const UserActionsMenu({
    super.key,
    required this.userId,
    required this.userName,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final l = S.of(context)!;

    return PopupMenuButton(
      itemBuilder: (context) {
        // Capture context for async callbacks
        final menuContext = context;
        
        return [
          PopupMenuItem(
            onTap: () {
              Future.delayed(Duration.zero, () {
                showModalBottomSheet(
                  context: menuContext,
                  isScrollControlled: true,
                  builder: (context) => ReportBottomSheet(
                    reportedUserId: userId,
                    reportedUserName: userName,
                    onSuccess: onSuccess,
                  ),
                );
              });
            },
            child: Row(
              children: [
                const Icon(Icons.flag, size: 20),
                const SizedBox(width: 12),
                Text(l.report),
              ],
            ),
          ),
          PopupMenuItem(
            onTap: () {
              Future.delayed(Duration.zero, () {
                showDialog(
                  context: menuContext,
                  builder: (context) => BlockConfirmDialog(
                    blockedUserName: userName,
                    blockedUserId: userId,
                    onSuccess: onSuccess,
                  ),
                );
              });
            },
            child: Row(
              children: [
                const Icon(Icons.block, size: 20),
                const SizedBox(width: 12),
                Text(l.block),
              ],
            ),
          ),
        ];
      },
      child: const Icon(Icons.more_vert),
    );
  }
}
