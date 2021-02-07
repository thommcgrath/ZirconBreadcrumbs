# Version History

## Version 2.0.0 - February 7th, 2021

- Requires Xojo 2020r2 and ArtisanKit 1.2.2.
- Modernized visual style.
- Supports dark mode.
- Now supports borders on all sides. Use the new constants BorderLeft and BorderRight. Constants can be OR'd together to enable multiple borders.
- IconTypeTemplate is deprecated. Use IconTypeMask instead to achieve the same effect. Masked icons are black and white images with no alpha channel.
- Add IconTypeAlpha constant. Alpha icons are templated icons that use the original icon's alpha channel.
- Removed properties PrimaryTextColor, PrimaryTextShadowColor, AlternateTextColor, and AlternateTextShadowColor.
- Removed Paint event.
- Added ColorGroup properties ActiveBackgroundColor, ActiveTextColor, BackgroundColor, and TextColor.
- BorderColor property is now a ColorGroup instead of Color.

## Version 1.0.0 - October 17th, 2015

- Initial release.