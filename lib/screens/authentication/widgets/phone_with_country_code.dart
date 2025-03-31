import 'package:escooter_notes_app/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_input/phone_input_package.dart';

import '../../../../../utils/constants/sizes.dart';

class PhoneWithCountryCode extends StatelessWidget {
  const PhoneWithCountryCode({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return PhoneInput(
      key: const Key('phone-field'),
      controller: null,
      // Phone controller
      initialValue: null,
      // can't be supplied simultaneously with a controller
      shouldFormat: true,
      // default
      defaultCountry: IsoCode.EG,
      // default
      countryCodeStyle: TextStyle(
        color: AppColors.white,
        fontSize: Sizes.md,
      ),
      style: TextStyle(
        color: AppColors.white,
        fontSize: Sizes.md,
      ),

      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(8.0.r)),
        ),
        focusColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(8.0.r)),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 9.w),
        labelText: 'Phone',
        floatingLabelStyle: TextStyle(
          color: AppColors.white,
          fontSize: Sizes.md,
        ),
        hintStyle: const TextStyle(fontWeight: FontWeight.normal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0.r)),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      cursorColor: AppColors.white,
      validator: PhoneValidator.validMobile(),
      // default PhoneValidator.valid()
      isCountrySelectionEnabled: true,
      // default
      countrySelectorNavigator: CountrySelectorNavigator.dialog(
        height: 500.sp,
        // Optional: Adjust modal height
        width: 350.sp,
        // Optional: Adjust modal width
        countries: null,
        // Optional: List of countries to show
        favorites: [IsoCode.EG],
        // Optional: Add favorite countries
        addFavoriteSeparator: true,
        // Adds a separator between favorites and the rest
        showCountryCode: true,
        // Shows country code next to the name
        noResultMessage: "No countries found",
        // Message for no search results
        showSearchInput: true,
        // Enables search input
        searchInputDecoration: InputDecoration(
          fillColor: Colors.white,
          // Makes search input background white
          filled: true,
          hintText: "Search country",
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10.r), // Rounded corners for search input
          ),
        ),
        searchInputTextStyle: const TextStyle(
          color: Colors.black, // Search input text color
        ),
        defaultSearchInputIconColor: Colors.black,
        // Search icon color
        countryCodeStyle: TextStyle(
          color: Colors.black, // Country code text color
          fontSize: 14.sp,
        ),
        countryNameStyle: TextStyle(
          color: Colors.black, // Country name text color
          fontSize: 16.sp,
        ),
        flagSize: 24.sp,
        // Adjust flag size
        flagShape: BoxShape.circle,
        // Flag shape
        showCountryName: true,
        // Show country names
        showCountryFlag: true, // Show country flags
      ),
      showFlagInInput: true,
      // default
      flagShape: BoxShape.circle,
      //// default
      showArrow: true,
      // default
      flagSize: 24.sp,
      // default
      autofillHints: const [AutofillHints.telephoneNumber],
      // default to null
      enabled: true,
      // default
      autofocus: false,
      // default
      onChanged: (PhoneNumber? p) {
        if (p != null) {
          controller.text = '+${p.countryCode}${p.nsn}';
        }
      }, // default null
    );
  }
}
