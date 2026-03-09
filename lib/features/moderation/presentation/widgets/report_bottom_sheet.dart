import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/report_reason.dart';
import '../bloc/moderation_bloc.dart';

class ReportBottomSheet extends StatefulWidget {
  final String reportedUserId;
  final String reportedUserName;
  final VoidCallback onSuccess;

  const ReportBottomSheet({
    super.key,
    required this.reportedUserId,
    required this.reportedUserName,
    required this.onSuccess,
  });

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  String? _selectedReason;
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a reason')),
      );
      return;
    }

    context.read<ModerationBloc>().add(
          ModerationEvent.reportUserRequested(
            reportedId: widget.reportedUserId,
            reason: _selectedReason!,
            details: _detailsController.text.isEmpty ? null : _detailsController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context)!;
    final theme = Theme.of(context);

    return BlocListener<ModerationBloc, ModerationState>(
      listener: (context, state) {
        state.maybeWhen(
          success: (message, blockedIds) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.reportSent)),
            );
            Navigator.pop(context);
            widget.onSuccess();
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $message')),
            );
          },
          orElse: () {},
        );
      },
      child: Container(
        color: theme.scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Заголовок
                Text(
                  l.report,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Reporting ${widget.reportedUserName}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),

                // Выбор причины
                Text(
                  l.reason,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ..._buildReasonButtons(context, l),
                const SizedBox(height: 24),

                // Поле для деталей
                Text(
                  l.additionalDetails,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _detailsController,
                  maxLines: 3,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: l.detailsPlaceholder,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 24),

                // Кнопки действия
                BlocBuilder<ModerationBloc, ModerationState>(
                  builder: (context, state) {
                    final isLoading = state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );

                    return Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isLoading ? null : () => Navigator.pop(context),
                            child: Text(l.cancel),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleSubmit,
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Text(l.submitReport),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildReasonButtons(BuildContext context, S l) {
    final reasons = [
      (ReportReason.spam, l.spam),
      (ReportReason.harassment, l.inappropriate),
      (ReportReason.fakeProfile, l.fakeProfile),
      (ReportReason.explicitContent, 'Explicit Content'),
      (ReportReason.underage, 'Underage'),
      (ReportReason.other, l.otherReason),
    ];

    return reasons
        .map(
          (reasonPair) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ChoiceChip(
              selected: _selectedReason == reasonPair.$1,
              onSelected: (selected) {
                setState(() => _selectedReason = selected ? reasonPair.$1 : null);
              },
              label: Text(reasonPair.$2),
            ),
          ),
        )
        .toList();
  }
}
