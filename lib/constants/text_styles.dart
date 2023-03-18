import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'my_colors.dart';

//copied from darkMode

//arsenal

TextStyle displayMedium = GoogleFonts.dancingScript(
    textStyle: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: MyColors.black,
    )
);

TextStyle displaySmall = GoogleFonts.aclonica(
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: MyColors.purple3,
    )
);

TextStyle titleLarge = GoogleFonts.pacifico(
    textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.white
    )
) ;

TextStyle titleMedium = GoogleFonts.aBeeZee(textStyle: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: MyColors.black,
) );

TextStyle bodyLarge = GoogleFonts.aBeeZee(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    )
);

TextStyle bodyMedium = GoogleFonts.aBeeZee(
    textStyle: const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: MyColors.black
));


