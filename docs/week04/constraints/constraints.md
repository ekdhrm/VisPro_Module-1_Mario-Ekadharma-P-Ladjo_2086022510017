# Constraint Diagnosis

## Error 1: Horizontal RenderFlex Overflow in Header
![Error 1](<Error-1&2.png>)

**Rule Violated:** A `Row` passes unbounded horizontal constraints down to its children. The `Text` widget in the header sized itself to its natural width, which was much wider than the finite width of the screen, breaking out of the right boundary and causing a 630-pixel overflow.

**The Fix:** Wrap the `Text` inside an `Expanded` or `Flexible` widget to force it to accept a strict bounded width constraint from the `Row`.

---

## Error 2: Vertical RenderFlex Overflow in Cards
![Error 2](<Error-1&2.png>)

**Rule Violated:** Constraints go down, sizes go up, parent sets position. The parent `SizedBox` inside the GameCard passed down a rigid height constraint of exactly `40px` to the `Column`. However, the `Column` required much more vertical space to draw all the text and progress bars. Because it could not expand its parent, the content overflowed the bottom boundary by 52 pixels.

**The Fix:** Remove the strict `SizedBox(height: 40)` constraint and allow the `Column` to determine its natural height so it comfortably wraps its children.

---

## Error 3: Grid Aspect Ratio Overflow
![Error 3](<Error-3.png>)

**Rule Violated:** The parent (`SliverGrid`) imposed a strict, rigid height constraint via `childAspectRatio: 2.5`, but the child (`Column` with long text) sized itself larger than that rigid constraint, causing an 8.5-pixel bottom overflow.

**The Fix:** Lower the `childAspectRatio` in the `SliverGridDelegateWithFixedCrossAxisCount` from `2.5` to `1.8` to pass down a taller height constraint to the children.