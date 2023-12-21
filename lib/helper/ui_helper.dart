//! UI Spaces
import 'package:flutter/material.dart';

const double _tinySpace = 5.0;
const double _smallSpace = 10.0;
const double _semiMediumSpace = 15.0;
const double _largeSpace = 25.0;
const double _mediumSpace = 20.0;

//* Horizontal Space
const Widget horizontalSpaceTiny = SizedBox(width: _tinySpace);
const Widget horizontalSpaceSmall = SizedBox(width: _smallSpace);
const Widget horizontalSpaceMedium = SizedBox(width: _mediumSpace);
const Widget horizontalSpaceSemiMedium = SizedBox(width: _semiMediumSpace);
const Widget horizontalSpaceLarge = SizedBox(width: _largeSpace);

//Variable Horizontal Space
Widget horizontalSpace(double width) => SizedBox(width: width);

//* Vertical Space
const Widget verticalSpaceTiny = SizedBox(height: _tinySpace);
const Widget verticalSpaceSmall = SizedBox(height: _smallSpace);
const Widget verticalSpaceMedium = SizedBox(height: _mediumSpace);
const Widget verticalSpacesSemiMedium = SizedBox(height: _semiMediumSpace);
const Widget verticalSpacesLarge = SizedBox(height: _largeSpace);
