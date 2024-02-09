import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instreet/models/categories_model.dart';

// Colors
Color kprimaryColor = Color(0xFFFF4500);
Color ksecondaryColor = Color(0xff555C69);
Color kinputColor = Colors.green.shade100;
Color kpostColor = Color(0xfffCFEEE1);

ThemeData instreetTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  iconTheme: IconThemeData(color: Color(0xfff1BB273)),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: kprimaryColor,
    secondary: ksecondaryColor,
  ),
);

BoxDecoration kfillbox10 = BoxDecoration(
  color: kinputColor,
  borderRadius: BorderRadius.circular(10),
);
BoxDecoration kfillbox20 = BoxDecoration(
  color: kpostColor,
  borderRadius: BorderRadius.circular(20),
);

TextStyle kTextPopB24 =
    GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.bold);
TextStyle kTextPopM16 =
    GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w600);
TextStyle kTextPopB16 =
    GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.bold);
TextStyle kTextPopR16 =
    GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w400);
TextStyle kTextPopR14 =
    GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w400);
TextStyle kTextPopB14 =
    GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.bold);
TextStyle kTextPopR12 =
    GoogleFonts.poppins(fontSize: 12.0, fontWeight: FontWeight.w400);

List<Category> categories = [
  Category('Books', 'assets/images/book.jpg'),
  Category('Electronics', 'assets/images/electronics.png'),
  Category('Clothes', 'assets/images/cloothes.png'),
  Category('Art', 'assets/images/art.png'),
  Category('Toys', 'assets/images/toys.png'),
  Category('Sport', 'assets/images/sport.png'),
  Category('Saloon', 'assets/images/saloon4.jpg'),
  Category('Jawelry', 'assets/images/jawelry.png'),
  Category('Health', 'assets/images/health.jpg'),
  Category('Food', 'assets/images/food.png'),
  Category('Flowers', 'assets/images/flower.jpg'),
  Category('Other', 'assets/images/all.png')
];

double calculateGridHeight() {
  int numberOfRows = (categories.length / 4).ceil();
  return numberOfRows * 100.0;
}
