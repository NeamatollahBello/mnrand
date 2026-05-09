# Style Update Plan - mnrand App

## Step 1: Update Theme Colors ✅ DONE
- [x] Edit `lib/apptheme.dart`:
  - Primary: Orange (0xFFF97316) instead of DeepPurple
  - Secondary: Dark slate (0xFF0F172A)
  - Background: Light gray (0xFFF8FAFC)
  - Enable Material Design 3
  - Added color constants and bottomNavShadow

## Step 2: Style Bottom Navigation Bar ✅ DONE
- [x] Edit `lib/pagetemplate.dart`:
  - Wrap BottomNavigationBar in container with white background
  - Add rounded top corners (30px radius)
  - Add shadow like test app
  - Orange selected color (0xFFF97316), gray unselected (0xFF94A3B8)
  - Removed "New" button (now only 3 items: Daily, Reports, Settings)

## Step 3: Update Form Controls ✅ DONE
- [x] Style TextField (TTextEdit): Rounded 16px, light gray fill, orange focus
- [x] Style Combo (TCombobox): Rounded 16px, light gray fill, orange focus
- [x] Style DateEdit: Rounded 16px, light gray fill, orange focus
- [x] Style IntEdit: Rounded 16px, light gray fill, orange focus
- [x] Style DoubleEdit: Rounded 16px, light gray fill, orange focus
- [x] Style CheckBox: Container with rounded 12px, orange check
- [x] Style LookupEdit: Rounded 16px, light gray fill, orange focus

## Step 4: FAB Replacement ✅ DONE
- [x] Added FAB floating button that expands to show menu options
- [x] Speed dial style menu like test app
- [x] Orange color when closed, dark when open
- [x] Menu items with colored icons

## Step 5: Update Screens ✅ DONE
- [x] Update settings.dart: Grouped containers with icons, subtitles
- [x] Update reports.dart: Card style with icons, descriptions

## Step 6: Next Steps (TODO)
- [ ] Update dayly.dart (main screen)
- [ ] Update login.dart
- [ ] Update materials.dart, clients.dart
