# Design Tokens & Theming System

The template implements a complete Material 3 design system built on design tokens, locale-aware typography, and fluid transitions.

---

## 1. Design Tokens Scale

### Spacing (`AppSpacing`)
```dart
AppSpacing.xs    // 4px
AppSpacing.sm    // 8px
AppSpacing.md    // 12px
AppSpacing.lg    // 16px (Default page margin)
AppSpacing.xl    // 20px
AppSpacing.xxl   // 24px
AppSpacing.xxxl  // 32px
AppSpacing.huge  // 48px (Minimum touch target)
```

### Radii (`AppRadius`)
```dart
AppRadius.xs     // 4px
AppRadius.sm     // 8px (Cards, snackbars, chips)
AppRadius.md     // 12px (Buttons, inputs)
AppRadius.lg     // 16px (Dialogs)
AppRadius.xl     // 24px (Large modals)
AppRadius.full   // 999px (Pills, badges)
```

### Animation Durations & Curves (`AppDurations`)
```dart
AppDurations.fast    // 150ms
AppDurations.normal  // 250ms
AppDurations.medium  // 350ms
AppDurations.slow    // 500ms
```

---

## 2. Locale-Aware Typography

Arabic script requires zero letter-spacing to prevent breaking connected cursive letters. The typography engine dynamically adjusts font families and letter spacing:

- **English / Latin (`en`)**: Inter (`Inter-Regular`, `Inter-Medium`, `Inter-SemiBold`, `Inter-Bold`) with standard tracking.
- **Arabic (`ar`)**: IBM Plex Sans Arabic (`IBMPlexSansArabic-Regular`, etc.) with `letterSpacing: 0.0`.

Fonts are bundled locally in `assets/fonts/` with zero Google Fonts runtime network requests.

---

## 3. Semantic Theme Extensions (`AppColorsExtension`)

Access semantic tokens across light and dark modes with type safety:

```dart
final colors = context.appColors;

colors.success    // Green 600
colors.warning    // Amber 600
colors.error      // Red 600
colors.info       // Sky 600
colors.border     // Outline border
colors.surfaceHigh// High-emphasis container
```
