import 'dart:ui';

import 'suggestions_theme.dart';

const _green = Color(0xFF269B55);
const _ultramarineBlue = Color(0xFF346EF1);
const _azure = Color(0xFF0085FF);
const _darkOrange = Color(0xFFC85019);
const _orange = Color(0xFFF1601D);
const _yellow = Color(0xFFF5A718);
const _premiumYellow = Color(0xFFFFC847);
const _red = Color(0xFFF61830);
const _darkBrown = Color(0xFF1C0404);

const _black = Color(0xFF000000);
const _raisinBlack = Color(0xFF212121);
const _charlestonGreen = Color(0xFF292929);
const _balticSea = Color(0xFF2B2B2B);
const _darkCharcoal = Color(0xFF333333);
const _jet = Color(0xFF353535);
const _outerSpace = Color(0xFF464646);
const _gray = Color(0xFF9E9E9E);
const _davyGray = Color(0xFF585858);
const _nickel = Color(0xFF727272);
const _philippineGray = Color(0xFF8C8C8C);
const _argent = Color(0xFFC1C1C1);
const _lightSilver = Color(0xFFD2D8DF);
const _chineseWhite = Color(0xFFE0E0E0);
const _antiFlashWhite = Color(0xFFF3F3F3);
const _lightCultured = Color(0xFFF4F5F6);
const _cultured = Color(0xFFF8F8F8);
const _white = Color(0xFFFFFFFF);

const String _mainFontFamily = 'Rubik';

final defaultTheme = SuggestionsTheme(
  primaryBackgroundColor: _white,
  secondaryBackgroundColor: _lightCultured,
  thirdBackgroundColor: _antiFlashWhite,
  bottomSheetBackgroundColor: _cultured,
  actionBackgroundColor: _chineseWhite.withOpacity(0.8),
  actionColor: _darkCharcoal.withOpacity(0.15),
  fabColor: _raisinBlack.withOpacity(0.12),
  actionPressedColor: _darkCharcoal.withOpacity(0.2),
  disabledTextColor: _darkCharcoal.withOpacity(0.38),
  disabledTextButtonColor: _darkCharcoal.withOpacity(0.08),
  tonalButtonColor: _orange.withOpacity(0.12),
  focusedTextButtonColor: _orange.withOpacity(0.12),
  focusedTonalButtonColor: _orange.withOpacity(0.3),
  enabledTextColor: _orange,
  focusedTextColor: _darkOrange,
  dividerColor: _lightSilver,
  activatedUpvoteArrowColor: _orange,
  bugLabelColor: _red,
  completedTabColor: _green,
  dialogBarrierColor: _white.withOpacity(0.8),
  elevatedButtonColor: _orange,
  elevatedButtonTextColor: _white,
  errorColor: _red,
  fade: _black.withOpacity(0.65),
  featureLabelColor: _azure,
  focusedTextFieldBorderlineColor: _orange,
  fontFamily: _mainFontFamily,
  inProgressTabColor: _yellow,
  pressedElevatedButtonColor: _darkOrange,
  primaryIconColor: _darkCharcoal,
  primaryTextColor: _darkCharcoal,
  requestsTabColor: _orange,
  secondaryIconColor: _argent,
  secondaryTextColor: _philippineGray,
  upvoteArrowColor: _philippineGray,
);
