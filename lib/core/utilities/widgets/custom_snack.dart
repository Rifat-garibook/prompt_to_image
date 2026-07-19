import 'package:flutter/material.dart';
import 'package:flutter/services.dart';





class Utils {
  static DateTime? _lastSnackShownAt;
  static String? _lastSnackText;

  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static void customSnackBar({
    required context,
    required String snackText,
    SnackBarBehavior? snackBehavior,
    SnackBarAction? snackBarAction,
    double? snackTextSize,
    Color? snackTextColor,
    int? snackDuration,
    Color? snackBackgroundColor,
  }) {
    final now = DateTime.now();
    if (_lastSnackText == snackText &&
        _lastSnackShownAt != null &&
        now.difference(_lastSnackShownAt!).inMilliseconds < 1500) {
      return;
    }

    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    final snack = SnackBar(
      backgroundColor: Colors.white,
      behavior: snackBehavior ?? SnackBarBehavior.floating,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      // Only set margin if behavior is floating
      margin: (snackBehavior ?? SnackBarBehavior.floating) ==
              SnackBarBehavior.floating
          ? const EdgeInsets.all(15)
          : null,
      action: snackBarAction,
      content: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue,),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              snackText,
              style: TextStyle(
                color: Colors.black,
                fontSize: snackTextSize ?? 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      duration: Duration(seconds: snackDuration ?? 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);

    _lastSnackText = snackText;
    _lastSnackShownAt = now;
  }

  static void customSnackBarBottomOverlay({
    required BuildContext context,
    required String snackText,
    SnackBarAction? snackBarAction,
    double? snackTextSize,
    int? snackDuration,
    Color? snackBackgroundColor,
  }) {
    final now = DateTime.now();
    if (_lastSnackText == snackText &&
        _lastSnackShownAt != null &&
        now.difference(_lastSnackShownAt!).inMilliseconds < 1500) {
      return;
    }

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).viewPadding.bottom + 15,
        child: Material(
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: snackBackgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue,),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    snackText,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: snackTextSize ?? 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (snackBarAction != null) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: snackBarAction.onPressed,
                    child: Text(snackBarAction.label),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    _lastSnackText = snackText;
    _lastSnackShownAt = now;

    Future.delayed(Duration(seconds: snackDuration ?? 2)).then((_) {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  static void customSnackBarTop({
    required BuildContext context,
    required String snackText,
    SnackBarBehavior? snackBehavior,
    SnackBarAction? snackBarAction,
    double? snackTextSize,
    Color? snackTextColor,
    int? snackDuration,
    Color? snackBackgroundColor,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 10,
        right: 10,
        child: Material(
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: snackBackgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    snackText,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: snackTextSize ?? 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (snackBarAction != null) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: snackBarAction.onPressed,
                    child: Text(
                      snackBarAction.label,
                      style: TextStyle(
                        color: snackBarAction.textColor ?? Colors.black,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: snackDuration ?? 3)).then((_) {
      overlayEntry.remove();
    });
  }
}

class CustomDialog extends StatelessWidget {
  final String message;
  final double? textSize;
  final Color? textColor;
  final Color? backgroundColor;
  final String? title;

  const CustomDialog({
    super.key,
    required this.message,
    this.textSize,
    this.textColor,
    this.backgroundColor,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: backgroundColor ?? Colors.white,
      child: SizedBox(
        height: 236,
        width: 340,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50),
              Text(title ?? "", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Text(
                      message,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: textSize ?? 15,
                        fontWeight: FontWeight.w600,
                        color: textColor ?? Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  // const Divider(
                  //   height: 10,
                  //   color: AppColors.dividerColor,
                  //   thickness: 1,
                  //   indent: 0,
                  //   endIndent: 0,
                  // ),
                  const SizedBox(height: 10),
                  InkWell(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        // padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                            ),
                            //textDecoration: TextDecoration.underline,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
