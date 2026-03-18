# Widget Catalog

A living document of all reusable widgets extracted in this project.
Update this file every time a new shared widget is created or modified.

---

## Template

Copy this block for each new widget:

```
### WidgetName
- **File**: `lib/widgets/<subfolder>/<file_name>.dart`
- **Type**: StatelessWidget | ConsumerWidget | StatefulWidget
- **Purpose**: One-sentence description of what this widget does
- **Used in**: list every screen/file that imports it
- **Props**:
  | Name | Type | Required | Default | Description |
  |------|------|----------|---------|-------------|
  | prop | Type | ✅ / ❌ | — | what it does |
- **Example**:
  ```dart
  WidgetName(prop: value)
  ```
```

---

## Catalog

*(Add entries below as you extract widgets)*

---

### PrimaryButton
- **File**: `lib/widgets/buttons/primary_button.dart`
- **Type**: StatelessWidget
- **Purpose**: Full-width elevated button used as the primary CTA across all screens
- **Used in**: *(add screen names here)*
- **Props**:
  | Name | Type | Required | Default | Description |
  |------|------|----------|---------|-------------|
  | label | String | ✅ | — | Button text |
  | onPressed | VoidCallback? | ❌ | null | Tap handler; null disables the button |
  | isLoading | bool | ❌ | false | Shows a spinner and disables tap when true |
- **Example**:
  ```dart
  PrimaryButton(
    label: 'Sign In',
    onPressed: _handleSignIn,
    isLoading: authState.isLoading,
  )
  ```

---

### AppTextField
- **File**: `lib/widgets/inputs/app_text_field.dart`
- **Type**: StatelessWidget
- **Purpose**: Styled text input field with consistent border radius and padding, used in all forms
- **Used in**: *(add screen names here)*
- **Props**:
  | Name | Type | Required | Default | Description |
  |------|------|----------|---------|-------------|
  | label | String | ✅ | — | Floating label text |
  | hint | String? | ❌ | null | Placeholder text |
  | controller | TextEditingController? | ❌ | null | External controller |
  | obscureText | bool | ❌ | false | Hides text for passwords |
  | suffix | Widget? | ❌ | null | Trailing widget (e.g., eye icon) |
  | validator | String? Function(String?)? | ❌ | null | Form validation function |
  | keyboardType | TextInputType | ❌ | text | Keyboard type |
- **Example**:
  ```dart
  AppTextField(
    label: 'Email',
    hint: 'you@example.com',
    controller: _emailController,
    keyboardType: TextInputType.emailAddress,
    validator: (v) => v!.isEmpty ? 'Required' : null,
  )
  ```

---

### EmptyStateView
- **File**: `lib/widgets/states/empty_state_view.dart`
- **Type**: StatelessWidget
- **Purpose**: Centered empty state with icon, title, message, and optional CTA action
- **Used in**: *(add screen names here)*
- **Props**:
  | Name | Type | Required | Default | Description |
  |------|------|----------|---------|-------------|
  | title | String | ✅ | — | Headline text |
  | message | String | ✅ | — | Subtext description |
  | icon | IconData | ❌ | Icons.inbox_outlined | Icon above the title |
  | action | Widget? | ❌ | null | Optional button or link below the message |
- **Example**:
  ```dart
  EmptyStateView(
    title: 'No Chargers Nearby',
    message: 'Try searching in a different area.',
    icon: Icons.ev_station_outlined,
    action: PrimaryButton(label: 'Search Again', onPressed: _retry),
  )
  ```

---

### SectionHeader
- **File**: `lib/widgets/layout/section_header.dart`
- **Type**: StatelessWidget
- **Purpose**: Titled row with optional trailing action widget (e.g., "See all" link)
- **Used in**: *(add screen names here)*
- **Props**:
  | Name | Type | Required | Default | Description |
  |------|------|----------|---------|-------------|
  | title | String | ✅ | — | Section title text |
  | trailing | Widget? | ❌ | null | Widget shown on the right (e.g., TextButton) |
- **Example**:
  ```dart
  SectionHeader(
    title: 'Available Chargers',
    trailing: TextButton(onPressed: _seeAll, child: const Text('See all')),
  )
  ```

---

### StatusBadge
- **File**: `lib/widgets/cards/status_badge.dart`
- **Type**: StatelessWidget
- **Purpose**: Pill-shaped label for displaying status (e.g., Available, In Use)
- **Used in**: *(add screen names here)*
- **Props**:
  | Name | Type | Required | Default | Description |
  |------|------|----------|---------|-------------|
  | label | String | ✅ | — | Status text |
  | color | Color | ✅ | — | Color used for border and background tint |
- **Example**:
  ```dart
  StatusBadge(label: 'Available', color: Colors.green)
  StatusBadge(label: 'In Use', color: Colors.orange)
  ```

---

### AppBottomSheet
- **File**: `lib/widgets/sheets/app_bottom_sheet.dart`
- **Type**: StatelessWidget
- **Purpose**: Consistently styled bottom sheet wrapper with drag handle, title, and keyboard-safe padding
- **Used in**: *(add screen names here)*
- **Props**:
  | Name | Type | Required | Default | Description |
  |------|------|----------|---------|-------------|
  | title | String? | ❌ | null | Optional header title |
  | child | Widget | ✅ | — | Sheet content |
- **Example**:
  ```dart
  // Show the sheet
  AppBottomSheet.show(
    context,
    title: 'Select User Type',
    child: const UserTypeSelector(),
  );
  ```

---

## Barrel Export File

Keep `lib/widgets/widgets.dart` up to date whenever adding a new widget:

```dart
// lib/widgets/widgets.dart
export 'buttons/primary_button.dart';
export 'inputs/app_text_field.dart';
export 'states/empty_state_view.dart';
export 'layout/section_header.dart';
export 'cards/status_badge.dart';
export 'sheets/app_bottom_sheet.dart';
// add new exports here ↓
```

Then screens only need one import:

```dart
import 'package:ivygo_app/widgets/widgets.dart';
```
