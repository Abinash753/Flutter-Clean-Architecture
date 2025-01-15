import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/app_pallete.dart';

class AppTheme {
  static  _border([Color color = AppPallete.borderColor]) => OutlineInputBorder( 
        borderSide: BorderSide( color: color, width: 3),
        borderRadius: BorderRadius.circular(10)
      );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: AppBarTheme( 
      backgroundColor: AppPallete.backgroundColor
    ),
    inputDecorationTheme: InputDecorationTheme( 
      contentPadding: EdgeInsets.all(25),
      enabledBorder: _border(),
      border: _border(),
      focusedBorder: _border(AppPallete.gradient2),
      errorBorder: _border(AppPallete.errorColor)

    ),
    //theme for chip widget
    chipTheme: ChipThemeData(
      side: BorderSide.none,
      color: MaterialStatePropertyAll(AppPallete.backgroundColor),
    
    )
  );
}
