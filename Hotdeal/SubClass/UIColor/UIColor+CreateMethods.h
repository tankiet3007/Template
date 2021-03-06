//
//  UIColor+CreateMethods.h
//  PromptuApp
//
//  Created by Brandon Millman on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CreateMethods)

// wrapper for [UIColor colorWithRed:green:blue:alpha:]
// values must be in range 0 - 255
+ (UIColor*)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

// Creates color using hex representation
// hex - must be in format: #FF00CC
// alpha - must be in range 0.0 - 1.0
+ (UIColor*)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHex:(int)hex;
+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (NSArray *)allColors;

+ (UIColor *)APAliceBlue;
+ (UIColor *)APAntiqueWhite;
+ (UIColor *)APAqua;
+ (UIColor *)APAquamarine;
+ (UIColor *)APAzure;
+ (UIColor *)APBeige;
+ (UIColor *)APBisque;
+ (UIColor *)APBlack;
+ (UIColor *)APBlanchedAlmond;
+ (UIColor *)APBlue;
+ (UIColor *)APBlueViolet;
+ (UIColor *)APBrown;
+ (UIColor *)APBurlyWood;
+ (UIColor *)APCadetBlue;
+ (UIColor *)APChartreuse;
+ (UIColor *)APChocolate;
+ (UIColor *)APCoral;
+ (UIColor *)APCornflowerBlue;
+ (UIColor *)APCornsilk;
+ (UIColor *)APCrimson;
+ (UIColor *)APCyan;
+ (UIColor *)APDarkBlue;
+ (UIColor *)APDarkCyan;
+ (UIColor *)APDarkGoldenrod;
+ (UIColor *)APDarkGray;
+ (UIColor *)APDarkGreen;
+ (UIColor *)APDarkKhaki;
+ (UIColor *)APDarkMagenta;
+ (UIColor *)APDarkOliveGreen;
+ (UIColor *)APDarkOrange;
+ (UIColor *)APDarkOrchid;
+ (UIColor *)APDarkRed;
+ (UIColor *)APDarkSalmon;
+ (UIColor *)APDarkSeaGreen;
+ (UIColor *)APDarkSlateBlue;
+ (UIColor *)APDarkSlateGray;
+ (UIColor *)APDarkTurquoise;
+ (UIColor *)APDarkViolet;
+ (UIColor *)APDeepPink;
+ (UIColor *)APDeepSkyBlue;
+ (UIColor *)APDimGray;
+ (UIColor *)APDodgerBlue;
+ (UIColor *)APFirebrick;
+ (UIColor *)APFloralWhite;
+ (UIColor *)APForestGreen;
+ (UIColor *)APFuchsia;
+ (UIColor *)APGainsboro;
+ (UIColor *)APGhostWhite;
+ (UIColor *)APGold;
+ (UIColor *)APGoldenrod;
+ (UIColor *)APGray;
+ (UIColor *)APGreen;
+ (UIColor *)APGreenYellow;
+ (UIColor *)APHoneydew;
+ (UIColor *)APHotPink;
+ (UIColor *)APIndianRed;
+ (UIColor *)APIndigo;
+ (UIColor *)APIvory;
+ (UIColor *)APKhaki;
+ (UIColor *)APLavender;
+ (UIColor *)APLavenderBlush;
+ (UIColor *)APLawnGreen;
+ (UIColor *)APLemonChiffon;
+ (UIColor *)APLightBlue;
+ (UIColor *)APLightCoral;
+ (UIColor *)APLightCyan;
+ (UIColor *)APLightGoldenrodYellow;
+ (UIColor *)APLightGray;
+ (UIColor *)APLightGreen;
+ (UIColor *)APLightPink;
+ (UIColor *)APLightSalmon;
+ (UIColor *)APLightSeaGreen;
+ (UIColor *)APLightSkyBlue;
+ (UIColor *)APLightSlateGray;
+ (UIColor *)APLightSteelBlue;
+ (UIColor *)APLightYellow;
+ (UIColor *)APLime;
+ (UIColor *)APLimeGreen;
+ (UIColor *)APLinen;
+ (UIColor *)APMagenta;
+ (UIColor *)APMaroon;
+ (UIColor *)APMediumAquamarine;
+ (UIColor *)APMediumBlue;
+ (UIColor *)APMediumOrchid;
+ (UIColor *)APMediumPurple;
+ (UIColor *)APMediumSeaGreen;
+ (UIColor *)APMediumSlateBlue;
+ (UIColor *)APMediumSpringGreen;
+ (UIColor *)APMediumTurquoise;
+ (UIColor *)APMediumVioletRed;
+ (UIColor *)APMidnightBlue;
+ (UIColor *)APMintCream;
+ (UIColor *)APMistyRose;
+ (UIColor *)APMoccasin;
+ (UIColor *)APNavajoWhite;
+ (UIColor *)APNavy;
+ (UIColor *)APOldLace;
+ (UIColor *)APOlive;
+ (UIColor *)APOliveDrab;
+ (UIColor *)APOrange;
+ (UIColor *)APOrangeRed;
+ (UIColor *)APOrchid;
+ (UIColor *)APPaleGoldenrod;
+ (UIColor *)APPaleGreen;
+ (UIColor *)APPaleTurquoise;
+ (UIColor *)APPaleVioletRed;
+ (UIColor *)APPapayaWhip;
+ (UIColor *)APPeachPuff;
+ (UIColor *)APPeru;
+ (UIColor *)APPink;
+ (UIColor *)APPlum;
+ (UIColor *)APPowderBlue;
+ (UIColor *)APPurple;
+ (UIColor *)APRed;
+ (UIColor *)APRosyBrown;
+ (UIColor *)APRoyalBlue;
+ (UIColor *)APSaddleBrown;
+ (UIColor *)APSalmon;
+ (UIColor *)APSandyBrown;
+ (UIColor *)APSeaGreen;
+ (UIColor *)APSeaShell;
+ (UIColor *)APSienna;
+ (UIColor *)APSilver;
+ (UIColor *)APSkyBlue;
+ (UIColor *)APSlateBlue;
+ (UIColor *)APSlateGray;
+ (UIColor *)APSnow;
+ (UIColor *)APSpringGreen;
+ (UIColor *)APSteelBlue;
+ (UIColor *)APTan;
+ (UIColor *)APTeal;
+ (UIColor *)APThistle;
+ (UIColor *)APTomato;
+ (UIColor *)APTransparent;
+ (UIColor *)APTurquoise;
+ (UIColor *)APViolet;
+ (UIColor *)APWheat;
+ (UIColor *)APWhite;
+ (UIColor *)APWhiteSmoke;
+ (UIColor *)APYellow;
+ (UIColor *)APYellowGreen;

@end

extern NSString * const AliceBlue;
extern NSString * const AntiqueWhite;
extern NSString * const Aqua;
extern NSString * const Aquamarine;
extern NSString * const Azure;
extern NSString * const Beige;
extern NSString * const Bisque;
extern NSString * const Black;
extern NSString * const BlanchedAlmond;
extern NSString * const Blue;
extern NSString * const BlueViolet;
extern NSString * const Brown;
extern NSString * const BurlyWood;
extern NSString * const CadetBlue;
extern NSString * const Chartreuse;
extern NSString * const Chocolate;
extern NSString * const Coral;
extern NSString * const CornflowerBlue;
extern NSString * const Cornsilk;
extern NSString * const Crimson;
extern NSString * const Cyan;
extern NSString * const DarkBlue;
extern NSString * const DarkCyan;
extern NSString * const DarkGoldenrod;
extern NSString * const DarkGray;
extern NSString * const DarkGreen;
extern NSString * const DarkKhaki;
extern NSString * const DarkMagenta;
extern NSString * const DarkOliveGreen;
extern NSString * const DarkOrange;
extern NSString * const DarkOrchid;
extern NSString * const DarkRed;
extern NSString * const DarkSalmon;
extern NSString * const DarkSeaGreen;
extern NSString * const DarkSlateBlue;
extern NSString * const DarkSlateGray;
extern NSString * const DarkTurquoise;
extern NSString * const DarkViolet;
extern NSString * const DeepPink;
extern NSString * const DeepSkyBlue;
extern NSString * const DimGray;
extern NSString * const DodgerBlue;
extern NSString * const Firebrick;
extern NSString * const FloralWhite;
extern NSString * const ForestGreen;
extern NSString * const Fuchsia;
extern NSString * const Gainsboro;
extern NSString * const GhostWhite;
extern NSString * const Gold;
extern NSString * const Goldenrod;
extern NSString * const Gray;
extern NSString * const Green;
extern NSString * const GreenYellow;
extern NSString * const Honeydew;
extern NSString * const HotPink;
extern NSString * const IndianRed;
extern NSString * const Indigo;
extern NSString * const Ivory;
extern NSString * const Khaki;
extern NSString * const Lavender;
extern NSString * const LavenderBlush;
extern NSString * const LawnGreen;
extern NSString * const LemonChiffon;
extern NSString * const LightBlue;
extern NSString * const LightCoral;
extern NSString * const LightCyan;
extern NSString * const LightGoldenrodYellow;
extern NSString * const LightGray;
extern NSString * const LightGreen;
extern NSString * const LightPink;
extern NSString * const LightSalmon;
extern NSString * const LightSeaGreen;
extern NSString * const LightSkyBlue;
extern NSString * const LightSlateGray;
extern NSString * const LightSteelBlue;
extern NSString * const LightYellow;
extern NSString * const Lime;
extern NSString * const LimeGreen;
extern NSString * const Linen;
extern NSString * const Magenta;
extern NSString * const Maroon;
extern NSString * const MediumAquamarine;
extern NSString * const MediumBlue;
extern NSString * const MediumOrchid;
extern NSString * const MediumPurple;
extern NSString * const MediumSeaGreen;
extern NSString * const MediumSlateBlue;
extern NSString * const MediumSpringGreen;
extern NSString * const MediumTurquoise;
extern NSString * const MediumVioletRed;
extern NSString * const MidnightBlue;
extern NSString * const MintCream;
extern NSString * const MistyRose;
extern NSString * const Moccasin;
extern NSString * const NavajoWhite;
extern NSString * const Navy;
extern NSString * const OldLace;
extern NSString * const Olive;
extern NSString * const OliveDrab;
extern NSString * const Orange;
extern NSString * const OrangeRed;
extern NSString * const Orchid;
extern NSString * const PaleGoldenrod;
extern NSString * const PaleGreen;
extern NSString * const PaleTurquoise;
extern NSString * const PaleVioletRed;
extern NSString * const PapayaWhip;
extern NSString * const PeachPuff;
extern NSString * const Peru;
extern NSString * const Pink;
extern NSString * const Plum;
extern NSString * const PowderBlue;
extern NSString * const Purple;
extern NSString * const Red;
extern NSString * const RosyBrown;
extern NSString * const RoyalBlue;
extern NSString * const SaddleBrown;
extern NSString * const Salmon;
extern NSString * const SandyBrown;
extern NSString * const SeaGreen;
extern NSString * const SeaShell;
extern NSString * const Sienna;
extern NSString * const Silver;
extern NSString * const SkyBlue;
extern NSString * const SlateBlue ;
extern NSString * const SlateGray;
extern NSString * const Snow;
extern NSString * const SpringGreen;
extern NSString * const SteelBlue;
extern NSString * const Tan;
extern NSString * const Teal;
extern NSString * const Thistle;
extern NSString * const Tomato;
extern NSString * const Transparent;
extern NSString * const Turquoise;
extern NSString * const Violet;
extern NSString * const Wheat;
extern NSString * const White;
extern NSString * const WhiteSmoke;
extern NSString * const Yellow;
extern NSString * const YellowGreen;

