# Extraction Patterns Reference

Common Flutter UI patterns that are strong candidates for extraction into reusable widgets.

---

## Table of Contents

1. [Buttons](#1-buttons)
2. [Cards & List Tiles](#2-cards--list-tiles)
3. [Form Fields & Inputs](#3-form-fields--inputs)
4. [Section Headers & Labels](#4-section-headers--labels)
5. [Empty States](#5-empty-states)
6. [Loading & Error States](#6-loading--error-states)
7. [Bottom Sheets & Dialogs](#7-bottom-sheets--dialogs)
8. [Avatar & Icon Containers](#8-avatar--icon-containers)
9. [Badges & Tags](#9-badges--tags)
10. [When NOT to Extract](#10-when-not-to-extract)

---

## 1. Buttons

### Signal: Same `ElevatedButton` / `TextButton` styling in multiple places
Extract a `PrimaryButton`, `SecondaryButton`, or `OutlineButton` wrapper.

```dart
// ✅ Extracted
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    );
  }
}
```

**Usage:**
```dart
PrimaryButton(label: 'Sign In', onPressed: _signIn, isLoading: authState.isLoading)
```

---

## 2. Cards & List Tiles

### Signal: `Container`/`Card` with the same padding, radius, or shadow across screens

```dart
// ✅ Extracted
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
```

---

## 3. Form Fields & Inputs

### Signal: Same `TextFormField` decoration repeated for each field

```dart
// ✅ Extracted
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.suffix,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
```

---

## 4. Section Headers & Labels

### Signal: `Text` with a specific style used as a section title, followed by a `Divider` or extra padding

```dart
// ✅ Extracted
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
```

---

## 5. Empty States

### Signal: Centered column with an icon, title, subtitle, and optional CTA button

```dart
// ✅ Extracted
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
            Icon(icon, size: 72, color: theme.colorScheme.outlineVariant),
            const SizedBox(height: 20),
            Text(title, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}
```

---

## 6. Loading & Error States

### Signal: `CircularProgressIndicator` wrapped in a `Center`, or an error `Text` inside a `Center` scattered across screens

```dart
// ✅ Extracted — handles all three async states
class AsyncStateView<T> extends StatelessWidget {
  final AsyncValue<T> state;
  final Widget Function(T data) builder;

  const AsyncStateView({super.key, required this.state, required this.builder});

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text('Something went wrong: $e',
            style: Theme.of(context).textTheme.bodyMedium),
      ),
      data: builder,
    );
  }
}
```

---

## 7. Bottom Sheets & Dialogs

### Signal: `showModalBottomSheet` call with the same container structure and padding

```dart
// ✅ Extracted — call this instead of showModalBottomSheet directly
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;

  const AppBottomSheet({super.key, this.title, required this.child});

  /// Convenience method — call from anywhere
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AppBottomSheet(title: title, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          if (title != null) ...[
            const SizedBox(height: 16),
            Text(title!, style: Theme.of(context).textTheme.titleLarge),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
```

---

## 8. Avatar & Icon Containers

### Signal: Circular containers with icons or network images repeated (e.g., charger type icons, user avatars)

```dart
// ✅ Extracted
class IconAvatar extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const IconAvatar({
    super.key,
    required this.icon,
    this.size = 48,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(icon,
          size: size * 0.5,
          color: iconColor ?? theme.colorScheme.onPrimaryContainer),
    );
  }
}
```

---

## 9. Badges & Tags

### Signal: Pill-shaped `Container` with text used for status labels (e.g., "Available", "In Use", "Fast Charging")

```dart
// ✅ Extracted
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StatusBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}
```

---

## 10. When NOT to Extract

Avoid over-extracting. Leave code inline when:

| Situation | Why |
|---|---|
| Widget is only used in one place and is < 15 lines | Not worth the indirection |
| Widget needs 8+ required parameters | Probably too specific; consider a data class instead |
| Widget body is a one-liner (e.g., `const SizedBox(height: 16)`) | Inline is cleaner |
| Widget tightly couples with a specific provider in a way that makes it non-reusable | Keep it in the screen |
| Extraction would force you to pass the BuildContext down many layers | Smell — rethink the design |
