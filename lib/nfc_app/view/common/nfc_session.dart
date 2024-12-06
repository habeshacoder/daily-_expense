import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_text_style.dart';

Future<void> startSession({
  required BuildContext context,
  required Future<dynamic> Function(NfcTag) handleTag,
  String alertMessage = 'Hold your device near the item.',
}) async {
  if (!(await NfcManager.instance.isAvailable())) {
    return showDialog(
      context: context,
      builder: (context) => _UnavailableDialog(),
    );
  }

  if (Platform.isAndroid) {
    return showDialog(
      context: context,
      builder: (context) => _AndroidSessionDialog(alertMessage, handleTag),
    );
  }

  if (Platform.isIOS) {
    return NfcManager.instance.startSession(
      alertMessage: alertMessage,
      onDiscovered: (tag) async {
        try {
          final result = await handleTag(tag);
          if (result == null) return;
          // await NfcManager.instance.stopSession(alertMessage: result);
        } catch (e) {
          // await NfcManager.instance.stopSession(errorMessage: '$e');
        }
      },
    );
  }

  throw ('unsupported platform: ${Platform.operatingSystem}');
}

class _UnavailableDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: mediumGrey,
      title: const Text(
        'Error',
        style: AppTextStyle.h3Normal,
      ),
      content: const Text(
        'NFC may not be supported or may be temporarily turned off.',
        style: AppTextStyle.h3Normal,
      ),
      actions: [
        TextButton(
          child: Text(
            'GOT IT',
            style: AppTextStyle.withColor(
              color: primaryColor,
              style: AppTextStyle.h3Normal,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class _AndroidSessionDialog extends StatefulWidget {
  const _AndroidSessionDialog(this.alertMessage, this.handleTag);

  final String alertMessage;

  final Future<dynamic> Function(NfcTag tag) handleTag;

  @override
  State<StatefulWidget> createState() => _AndroidSessionDialogState();
}

class _AndroidSessionDialogState extends State<_AndroidSessionDialog> {
  String? _alertMessage;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        try {
          print("********************");
          final result = await widget.handleTag(tag);
          print("######################");
          if (result == null) return;
          // await NfcManager.instance.stopSession();
          setState(() => _alertMessage = result);
        } catch (e) {
          //  .catchError((_) {/* no op */});
          setState(() => _errorMessage = '$e');
        }
      },
    ).catchError((e) => setState(() => _errorMessage = '$e'));
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession().catchError((_) {/* no op */});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: mediumGrey,
      title: Text(
        _errorMessage?.isNotEmpty == true
            ? 'Error'
            : _alertMessage?.isNotEmpty == true
                ? 'Success'
                : 'Ready to scan',
        style: AppTextStyle.h3Normal,
      ),
      content: Text(
        _errorMessage?.isNotEmpty == true
            ? _errorMessage!
            : _alertMessage?.isNotEmpty == true
                ? _alertMessage!
                : widget.alertMessage,
        style: AppTextStyle.h3Normal,
      ),
      actions: [
        TextButton(
          child: Text(
            _errorMessage?.isNotEmpty == true
                ? 'GOT IT'
                : _alertMessage?.isNotEmpty == true
                    ? 'OK'
                    : 'CANCEL',
            style: AppTextStyle.withColor(
              color: primaryColor,
              style: AppTextStyle.h3Normal,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
