import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';


int selectedService = 0;
int selectedCategory = 0;
bool isEnglish = true;

User? userConst;

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';

const String mainColor = '6d7400';
const String secondary = '303C47';
const String secondaryVariant = '6A6D78';

const String darkGreyColor = '989898';
const String regularGrey = 'E9E8E7';
const String liteGreyColor = 'F9F8F7';

const String greenColor = '07B055';
const String blueColor = '0E72ED';

const Color whiteColor = Colors.white;
const Color blackColor = Colors.black;

const Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (Route<dynamic> route) => false);

void debugPrintFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
}

class MyDivider extends StatelessWidget {
  const MyDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1.0,
      color: HexColor(regularGrey),
    );
  }
}

Future<File?> imageFromURL(String name, String imageUrl) async {
  if (imageUrl.isEmpty) return null;
// get temporary directory of device.
  Directory? tempDir = await () async {
    if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    return await getExternalStorageDirectory();
  }();
// get temporary path from temporary directory.
  String tempPath = tempDir!.path;
// create a new file in temporary path with file name.
  File file = File('$tempPath/' + name + '.png');
// call http.get method and pass imageUrl into it to get response.
  Response response = await get(Uri.parse(imageUrl));
  if (response.statusCode != 200) return null;
// write bodyBytes received in response to file.
  await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
  return file;
}

double responsiveValue(BuildContext context, double value) =>
    MediaQuery.of(context).size.width * (value / 375.0);

space3Vertical(BuildContext context) => SizedBox(
      height: responsiveValue(context, 3.0),
    );

space4Vertical(BuildContext context) => SizedBox(
      height: responsiveValue(context, 4.0),
    );

space5Vertical(BuildContext context) => SizedBox(
      height: responsiveValue(context, 5.0),
    );

space8Vertical(BuildContext context) => SizedBox(
      height: responsiveValue(context, 8.0),
    );

space10Vertical(BuildContext context) => SizedBox(
      height: responsiveValue(context, 10.0),
    );

space16Vertical(BuildContext context) => SizedBox(
      height: responsiveValue(context, 16.0),
    );

space20Vertical(BuildContext context) => SizedBox(
      height: responsiveValue(context, 20.0),
    );

space30Vertical(BuildContext context) => SizedBox(
      height: responsiveValue(context, 30.0),
    );

space40Vertical(BuildContext context) => SizedBox(
      height: responsiveValue(context, 40.0),
    );

space50Vertical(BuildContext context) => SizedBox(
      height: responsiveValue(context, 50.0),
    );

space60Vertical(BuildContext context) => SizedBox(
      height: responsiveValue(context, 60.0),
    );

space70Vertical(BuildContext context) => SizedBox(
      height: responsiveValue(context, 70.0),
    );

space80Vertical(BuildContext context) => SizedBox(
      height: responsiveValue(context, 80.0),
    );

space90Vertical(BuildContext context) => SizedBox(
      height: responsiveValue(context, 90.0),
    );

space100Vertical(BuildContext context) => SizedBox(
      height: responsiveValue(context, 100.0),
    );

space3Horizontal(BuildContext context) => SizedBox(
      width: responsiveValue(context, 3.0),
    );

space4Horizontal(BuildContext context) => SizedBox(
      width: responsiveValue(context, 4.0),
    );

space5Horizontal(BuildContext context) => SizedBox(
      width: responsiveValue(context, 5.0),
    );

space8Horizontal(BuildContext context) => SizedBox(
      width: responsiveValue(context, 8.0),
    );

space10Horizontal(BuildContext context) => SizedBox(
      width: responsiveValue(context, 10.0),
    );

space15Horizontal(BuildContext context) => SizedBox(
      width: responsiveValue(context, 15.0),
    );

space20Horizontal(BuildContext context) => SizedBox(
      width: responsiveValue(context, 20.0),
    );

space30Horizontal(BuildContext context) => SizedBox(
      width: responsiveValue(context, 30.0),
    );

space40Horizontal(BuildContext context) => SizedBox(
      width: responsiveValue(context, 40.0),
    );

space50Horizontal(BuildContext context) => SizedBox(
      width: responsiveValue(context, 50.0),
    );

space60Horizontal(BuildContext context) => SizedBox(
      width: responsiveValue(context, 60.0),
    );

space70Horizontal(BuildContext context) => SizedBox(
      width: responsiveValue(context, 70.0),
    );

space80Horizontal(BuildContext context) => SizedBox(
      width: responsiveValue(context, 80.0),
    );

space90Horizontal(BuildContext context) => SizedBox(
      width: responsiveValue(context, 90.0),
    );

space100Horizontal(BuildContext context) => SizedBox(
      width: responsiveValue(context, 100.0),
    );
