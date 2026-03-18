---
name: flutter-widget-extractor
description: Use when creating reusable Flutter widgets, refactoring screens to extract shared UI components, or when a project already has screens that contain repeated or complex UI patterns that should be moved into a dedicated widgets/ folder. Invoke this skill whenever the user says "extract widgets", "make this reusable", "refactor UI components", "DRY up my Flutter screens", "create shared widgets", or when building any new feature that involves UI elements that could be reused elsewhere. Always use this skill even if the user just says "add a widget folder" or "clean up my UI code" in a Flutter project.
license: MIT
metadata:
  version: "1.0.0"
  domain: frontend
  triggers: Flutter, widget, reusable, extract, refactor, DRY, shared components, widget folder
  role: specialist
  scope: implementation
  output-format: code
  related-skills: flutter-expert, flutter-animations
---

# Flutter Widget Extractor

Senior Flutter engineer that identifies, extracts, and organizes reusable UI components from Flutter screens into a clean, shared `widgets/` folder — keeping screens lean and the codebase DRY.

## When to Use This Skill

- Any Flutter project where screens contain repeated UI patterns
- Refactoring a project that has grown and has duplicated widget code
- Starting a new feature and needing a shared component library
- When `flutter analyze` or code review flags high widget nesting in screens
- When building a design system on top of an existing Flutter app

## Core Workflow

### Phase 1 — Audit & Discover
1. **Scan all screens** in `lib/features/**/presentation/screens/` (and any other screen directories)
2. **List unique UI patterns** observed across screens
3. **Identify candidates** using the extraction criteria below
4. **Create an extraction plan** — list each widget, its source file(s), and target output file

### Phase 2 — Extract
1. **Create the widget file** in `lib/widgets/` (see folder structure below)
2. **Write the widget** following flutter-expert constraints (const, proper keys, no setState for app-wide state)
3. **Replace inline code** in the original screen(s) with the new widget
4. **Add the import** at the top of each consuming screen
5. **Run `flutter analyze`** and fix any issues before moving to the next widget

### Phase 3 — Verify
1. Run `flutter analyze` — must be clean
2. Run `flutter test` if tests exist — must pass
3. Confirm the screens still look and behave identically

---

## Extraction Criteria

**DO extract** a widget when any of these are true:
- The UI block appears in **2 or more** files, even with minor variations
- The widget is **complex** (deeply nested, 20+ lines) even if used once — it deserves its own class for readability
- It represents a **semantic concept** (e.g., `ChargerCard`, `SectionHeader`, `EmptyStateView`) that makes screens self-documenting
- It contains **its own internal state or logic** that can be cleanly scoped (e.g., an expandable section)

**DON'T extract** when:
- The widget is trivially small (e.g., a single `Text` with a specific string)
- Its props are so specific to one screen's business logic that parameterizing it would be worse than leaving it inline
- Extraction would break a Riverpod `ConsumerWidget` in a way that makes the state harder to manage

---

## Widget Folder Structure

```
lib/
└── widgets/
    ├── buttons/          # CTAs, icon buttons, text buttons
    ├── cards/            # Content cards, list tiles, charger cards
    ├── inputs/           # Text fields, dropdowns, search bars
    ├── layout/           # Scaffolds, paddings, dividers, section headers
    ├── states/           # Empty state, loading, error widgets
    └── sheets/           # Bottom sheets, modals, drawers
```

For small projects or early-stage codebases, a flat `lib/widgets/` is fine — use sub-folders when you have **5+ widgets**.

---

## Naming Conventions

| Pattern | Example |
|---|---|
| Feature-specific prefix | `ChargerCard`, `StationHeader`, `MapOverlayButton` |
| Generic/shared | `PrimaryButton`, `SectionLabel`, `EmptyStateView` |
| State-descriptive | `LoadingCard`, `ErrorBanner`, `SuccessSnackbar` |
| Never generic | ~~`MyWidget`~~, ~~`CustomWidget1`~~ |

Use **PascalCase** for class names and **snake_case** for file names:
- Class: `ChargerListTile` → File: `charger_list_tile.dart`

---

## Code Templates

### Basic Stateless Widget (most common)

```dart
// lib/widgets/cards/charger_card.dart
import 'package:flutter/material.dart';

class ChargerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ChargerCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(subtitle, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
```

### Riverpod-aware Shared Widget

```dart
// lib/widgets/states/loading_overlay.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingOverlay extends ConsumerWidget {
  final AsyncValue asyncValue;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.asyncValue,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return asyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (_) => child,
    );
  }
}
```

### Empty State Widget

```dart
// lib/widgets/states/empty_state_view.dart
import 'package:flutter/material.dart';

class EmptyStateView extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Widget? action;

  const EmptyStateView({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}
```

---

## Before / After Example

### ❌ Before — duplicated button code in two screens

```dart
// sign_in_screen.dart
ElevatedButton(
  onPressed: _onSignIn,
  style: ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 52),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  child: const Text('Sign In'),
)

// create_account_screen.dart
ElevatedButton(
  onPressed: _onCreate,
  style: ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 52),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  child: const Text('Create Account'),
)
```

### ✅ After — shared widget, screens are clean

```dart
// lib/widgets/buttons/primary_button.dart
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const PrimaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label),
    );
  }
}

// sign_in_screen.dart
PrimaryButton(label: 'Sign In', onPressed: _onSignIn)

// create_account_screen.dart
PrimaryButton(label: 'Create Account', onPressed: _onCreate)
```

---

## Constraints

Align with `flutter-expert` skill:

### MUST DO
- Use `const` constructors on all extracted widgets
- Pass `super.key` in the constructor
- Use `Theme.of(context)` for colors/text styles — never hardcode
- Export widgets via a `lib/widgets/widgets.dart` barrel file after extraction
- Run `flutter analyze` after every extraction and fix all warnings
- Add a docstring comment above the class describing the widget's purpose

### MUST NOT DO
- Hardcode colors or font sizes in the widget — use the theme
- Put business logic or API calls inside extracted widgets (those belong in providers/notifiers)
- Use `StatefulWidget` when the state can be lifted to a Riverpod provider
- Create widgets so generic they require 10+ parameters — split into variants instead

---

## Output After Extraction

When you finish extracting widgets, provide a summary like this:

```
## Extracted Widgets

| Widget | File | Replaces Code In |
|--------|------|-----------------|
| PrimaryButton | lib/widgets/buttons/primary_button.dart | sign_in_screen.dart, create_account_screen.dart |
| ChargerCard | lib/widgets/cards/charger_card.dart | chargers_list_screen.dart |
| EmptyStateView | lib/widgets/states/empty_state_view.dart | chargers_empty_screen.dart |
| SectionHeader | lib/widgets/layout/section_header.dart | station_detail_screen.dart, map_home_screen.dart |
```

Then run `flutter analyze` and paste the output.

---

## Reference Files

Load these when you need deeper guidance:

| Topic | File | When to Load |
|-------|------|-------------|
| Common extraction patterns | `references/extraction-patterns.md` | When deciding what to extract and how |
| Widget catalog template | `references/widget-catalog.md` | When documenting extracted widgets |
