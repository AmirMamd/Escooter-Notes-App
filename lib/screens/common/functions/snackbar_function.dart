import 'package:escooter_notes_app/utils/enums/enums.dart';
import 'package:escooter_notes_app/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showSnackBar(BuildContext context, String message,
    {MessageType messageType = MessageType.failure}) {
  if (messageType == MessageType.failure) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        icon: const SizedBox.shrink(),
        message: message,
        backgroundColor: AppColors.primary,
        textStyle: Theme.of(context).textTheme.labelLarge!,
      ),
    );
  } else {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        icon: const SizedBox.shrink(),
        message: message,
        backgroundColor: Colors.green,
        textStyle: Theme.of(context).textTheme.labelLarge!,
      ),
    );
  }
}
