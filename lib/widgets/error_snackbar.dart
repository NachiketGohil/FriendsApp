import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorSnackbar {
  // String errorMsg = '';
  // bool wantLoading = false;
  //
  // ErrorSnackbar({
  //   Key? key,
  //   required this.errorMsg,
  //   required this.wantLoading,
  // }) : super(key: key);

  ErrorSnackbar._();
  static buildErrorSnackbar({
    required BuildContext context,
    required String errorMsg,
    required bool wantLoading,
  }) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(errorMsg),
            wantLoading
                ? const SizedBox(
                    height: 26,
                    width: 26,
                    child: CircularProgressIndicator(
                      color: Colors.yellow,
                      strokeWidth: 2,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return SnackBar(
      duration: const Duration(seconds: 2),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(errorMsg),
          wantLoading
              ? const SizedBox(
                  height: 26,
                  width: 26,
                  child: CircularProgressIndicator(
                    color: Colors.yellow,
                    strokeWidth: 2,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
  */
}
