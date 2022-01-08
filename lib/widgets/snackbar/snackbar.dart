import 'package:flutter/material.dart';
import 'package:flutter_helper/models/error.dart';

class CustomErrorSnackBar {
  static String getError(ex) {
    var message = ex.toString();
    if (ex is BadRequestError) {
      message = ex.error?.message ?? '';
    }
    if (ex is NotFoundError) {
      message = ex.error?.message ?? '';
    }
    if (ex is InternalServerError) {
      message = ex.error?.message ?? '';
    }
    if (ex is AuthorizeError) {
      message = ex.error?.message ?? '';
    }
    if (ex is ErrorModel) {
      message = ex.message ?? '';
    }
    return message;
  }

  static void showSnackBar(BuildContext context, ex, {Color? color, VoidCallback? refreshToken}) {
    var message = ex.toString();
    var code = 0;
    if (ex is BadRequestError) {
      message = ex.error?.message ?? '';
      code = ex.error?.code ?? 0;
    }
    if (ex is NotFoundError) {
      message = ex.error?.message ?? '';
      code = ex.error?.code ?? 0;
    }
    if (ex is InternalServerError) {
      message = ex.error?.message ?? '';
      code = ex.error?.code ?? 0;
    }
    if (ex is AuthorizeError) {
      message = ex.error?.message ?? '';
      code = ex.error?.code ?? 0;
    }
    if (ex is ErrorModel) {
      message = ex.message ?? '';
      code = ex.code ?? 0;
    }

    var snackbar = SnackBar(
      content: Text(message),
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      action: code == 401
          ? SnackBarAction(
              label: 'Giriş Yap',
              textColor: Colors.white,
              // ignore: avoid_print
              onPressed: refreshToken ?? () => print("Login"),
            )
          : null,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: color ?? Colors.redAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static void showSnackBarWithText(BuildContext context, String? text, {Color? color, bool? showTop}) {
    var h = (MediaQuery.of(context).size.height);
    var kh = h / 5;
    var snackbar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(text ?? "Hata mesajı gösterirken bir hata oluştu. Lütfen daha sonra tekrar deneyiniz"),
      margin: showTop == true ? EdgeInsets.only(bottom: h - kh, right: 20, left: 20) : const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: color ?? Colors.redAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
