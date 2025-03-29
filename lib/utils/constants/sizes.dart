import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Sizes{
  Sizes._();

  //Padding and Margin Sizes
  static final double xs = 4.0.sp;
  static final double sm = 8.0.sp;
  static final double md = 12.0.sp;
  static final double lg = 24.0.sp;
  static final double xl = 32.0.sp;

  //Icon Sizes
  static final double iconXs = 12.0.sp;
  static final double iconSm = 16.0.sp;
  static final double iconMd = 24.0.sp;
  static final double iconLg = 32.0.sp;
  
  //Font Sizes
  static final double fontSizeSm = 14.0.sp;
  static final double fontSizeMd = 16.0.sp;
  static final double fontSizeLg = 24.0.sp;

  //Button Sizes
  static final double buttonHeight = 40.0.h;
  static final double buttonRadius = 12.0.r;
  static final double buttonWidth = 120.0.w;
  static final double buttonElevation = 4.0.sp;
  
  //AppBar Height
  static final double appBarHeight = 56.0.h;

  //Image Sizes
  static final double imageThumbSize = 80.0.sp;

  //Default Spacing between Sections
  static final double defaultSpace = 24.0.sp;
  static final double spaceBetweenItems = 15.0.sp;
  static final double spaceBetweenSections = 32.0.sp;
  
  //Border Radius
  static final double borderRadiusSm = 4.0.r;
  static final double borderRadiusMd = 8.0.r;
  static final double borderRadiusLg = 12.0.r;

  //Divider Height
  static final double dividerHeight = 1.0.h;

  //Product Item Dimensions
  static final double productImageSize = 120.0.sp;
  static final double productImageRadius = 16.0.r;
  static final double productItemHeight = 160.0.h;

  //Input Field
  static final double inputFieldRadius = 12.0.r;
  static final double spaceBetweenInputFields = 16.0.sp;

  // Card Sizes
  static final double cardRadiusLg = 16.0.r;
  static final double cardRadiusMd = 12.0.r;
  static final double cardRadiusSm = 10.0.r;
  static final double cardRadiusXs = 6.0.r;
  static final double cardElevation = 2.0.sp;

  //Image Carousel Height
  static final double imageCarouselHeight = 200.0.h;

  //Loading Indicator Size
  static final double loadingIndicatorSize = 36.0.sp;

  //Grid View Spacing
  static final double gridViewSpacing = 16.0.sp;
 
}

extension SizeBoxExtension on num {
  SizedBox get hSpacer => SizedBox(height: toDouble().h);
  SizedBox get wSpacer => SizedBox(width: toDouble().w);
}
