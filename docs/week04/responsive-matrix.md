# Responsive Matrix - Week 04

| Test | Screen / Condition | Pass/Fail | Fixes Applied / Notes |
| :--- | :--- | :--- | :--- |
| **Small Phone** | Emulator at 320 dp width | Pass | Used `CustomScrollView` and `SliverList` to allow fluid vertical scrolling without horizontal overflows. |
| **Large Phone** | Emulator at 430 dp width | Pass | Layout fills the available space naturally without constraint issues. |
| **Tablet** | Emulator at 800 dp width | Pass | `LayoutBuilder` successfully switches to `SliverGrid`. *Fix applied: Lowered `childAspectRatio` from 2.5 to 1.8 to prevent an 8.5px vertical overflow when displaying long text.* |
| **Landscape** | Rotate every emulator above | Pass | Breakpoint (> 600dp) correctly triggers the 2-column grid layout for wider horizontal space. |
| **Long Text** | Item name of 200 characters | Pass | Added `maxLines: 2` and `overflow: TextOverflow.ellipsis` to the `Text` widgets inside `GameCard`. |
| **Empty State** | Zero items | Pass | Handled using `SliverFillRemaining`. Added an Icon, a text message, and a 'Reset Search' Action button. Included `key: const Key('empty-state')`. |
| **Long List** | 500 items, using `.builder` | Pass | Handled natively by `SliverChildBuilderDelegate` for lazy loading. Ensured no `shrinkWrap: true` was used to maintain performance. |
| **Keyboard** | Open a text field on short screen | Pass | Replaced the rigid `Column` + `Expanded` layout with a `CustomScrollView`. The layout now safely scrolls up instead of triggering a bottom overflow when the keyboard appears. |
| **Dark Mode** | Still legible | Pass | Legibility is maintained natively using Material 3 `ColorScheme.fromSeed` configured with `Brightness.dark`. |