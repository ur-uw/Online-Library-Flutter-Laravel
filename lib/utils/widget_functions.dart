import 'package:auth_laravel/services/AuthService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'constants.dart';

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

Text text(
  String text, {
  double fontSize,
  Color color,
  String fontFamily,
  FontWeight fontWeight,
  TextAlign textAlign,
  TextDirection textDirection,
  double lineHeight,
  double letterSpacing,
  double wordSpacing,
  TextStyle style,
}) {
  return Text(
    text,
    textAlign: textAlign,
    textDirection: textDirection,
    style: style ??
        TextStyle(
          fontSize: fontSize,
          color: color,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          height: lineHeight,
          wordSpacing: wordSpacing,
        ),
  );
}

//Removing Scroll glow
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

List<Widget> buildRandomListItems({int numberOfItems = 5, bool isVertical = true}) {
  List<Widget> items = [];
  for (var i = 0; i < numberOfItems; i++) {
    items.add(
      isVertical
          ? Container(
              padding: EdgeInsets.all(15),
              height: 150,
              child: text('test'),
            )
          : Container(
              padding: EdgeInsets.all(15),
              width: 150,
              child: text('test'),
            ),
    );
  }
  return items;
}

showWarning({String title, String message, Duration duration}) {
  Get.showSnackbar(
    GetBar(
      title: title.tr,
      message: message.tr,
      dismissDirection: SnackDismissDirection.VERTICAL,
      snackPosition: SnackPosition.BOTTOM,
      duration: duration ?? Duration(seconds: 5),
      backgroundColor: Color(0xffe63946),
      leftBarIndicatorColor: Colors.redAccent[700],
      icon: Icon(Icons.warning, color: Colors.yellowAccent[700]),
      shouldIconPulse: true,
    ),
  );
}

showSuccess({String title, String message, Duration duration, String email, SnackPosition position}) {
  Get.showSnackbar(
    GetBar(
      title: title.tr,
      message: message.tr + " ${email ?? ''}",
      dismissDirection: SnackDismissDirection.VERTICAL,
      snackPosition: position ?? SnackPosition.BOTTOM,
      duration: duration ?? Duration(seconds: 5),
      backgroundColor: Color(0xff52b788),
      leftBarIndicatorColor: Colors.blueGrey,
      icon: Icon(Icons.check_circle, color: Colors.white),
      shouldIconPulse: true,
    ),
  );
}

showInfo({
  String title,
  String message,
  TextButton button,
  Duration duration,
  SnackPosition position,
}) {
  Get.showSnackbar(
    GetBar(
      title: title.tr,
      message: message.tr,
      dismissDirection: SnackDismissDirection.VERTICAL,
      snackPosition: position ?? SnackPosition.BOTTOM,
      duration: duration ?? Duration(seconds: 3),
      backgroundColor: black,
      leftBarIndicatorColor: Colors.blueGrey,
      mainButton: button,
      icon: Icon(Icons.info_outline, color: Colors.white),
      shouldIconPulse: true,
    ),
  );
}

Container buildFormField({
  String labelText,
  TextDirection textDirection,
  String hintText,
  TextStyle labelStyle,
  TextEditingController fieldController,
  InputBorder inputBorder,
  InputBorder focusedBorder,
  Function(String) validator,
  double height,
  double width,
  int maxLines = 1,
  TextStyle hintStyle,
  IconData prefixIcon,
  bool showBorder = false,
  bool floatLabel = false,
  bool isPassword = false,
}) {
  return Container(
    height: height,
    width: width,
    child: TextFormField(
      controller: fieldController,
      validator: validator,
      maxLines: maxLines,
      textDirection: textDirection,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        floatingLabelBehavior: floatLabel ? FloatingLabelBehavior.always : FloatingLabelBehavior.auto,
        labelText: labelText,
        hintStyle: hintStyle,
        hintText: hintText,
        labelStyle: labelStyle,
        focusedBorder: focusedBorder ?? inputBorder,
        border: inputBorder ?? OutlineInputBorder(borderSide: showBorder ? BorderSide(color: black) : BorderSide.none),
      ),
    ),
  );
}

bool checkIfTheKeyboardIsOn(BuildContext context) {
  if (MediaQuery.of(context).viewInsets.bottom != 0) return true;
  return false;
}

Drawer appDrawer(String profileImage, String name) {
  return Drawer(
    elevation: 0,
    child: Container(
      color: black,
      padding: EdgeInsets.all(10),
      child: ListView(
        children: [
          Container(
            height: Get.height / 4.5,
            padding: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(profileImage), fit: BoxFit.contain),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(child: text(name, style: defaultTextStyle, textAlign: TextAlign.center))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: Get.height / 10),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.menu_book_sharp,
                      color: black,
                    ),
                    title: text('My books'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.favorite,
                      color: black,
                    ),
                    title: text('Favorites'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: black,
                    ),
                    title: text('Settings'),
                  ),
                ),
                Card(
                  child: ListTile(
                    onTap: () async {
                      try {
                        String token = await FlutterSecureStorage().read(key: 'token');
                        await FlutterSecureStorage().deleteAll();
                        await AuthService().logOut(token);
                        Get.offAllNamed('/');
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    leading: Icon(
                      Icons.logout,
                      color: black,
                    ),
                    title: text('Logout'),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
