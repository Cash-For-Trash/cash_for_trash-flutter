import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AppExitPopScope extends StatefulWidget {
  final Widget child;

  const AppExitPopScope({
    super.key,
    required this.child,
  });

  @override
  State<AppExitPopScope> createState() => _AppExitPopScopeState();
}

class _AppExitPopScopeState extends State<AppExitPopScope> {
  bool _isDialogShowing = false;

  Future<void> _onPopInvoked(bool didPop) async {
    if (didPop || _isDialogShowing) return;

    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
      return;
    }

    _isDialogShowing = true;

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(dialogContext).scaffoldBackgroundColor,
          title: Text(
            context.tr('exit_title'),
            style: TextStyle(
              color: Theme.of(dialogContext).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            context.tr('exit_confirm'),
            style: TextStyle(
              color: Theme.of(dialogContext).colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                context.tr('no'),
                style: TextStyle(
                  color: Theme.of(dialogContext).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                context.tr('yes'),
                style: TextStyle(
                  color: Theme.of(dialogContext).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    _isDialogShowing = false;

    if (shouldExit == true) {
      await SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _onPopInvoked(didPop),
      child: widget.child,
    );
  }
}