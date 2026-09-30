## Case Study

The application itself is a game progress tracker intended to help a player
to keep track of their progression in story-heavy and grinding games.
The idea comes from the need to frequently use Discord to search for
information, remember previous progress, or track what still needs
to be completed.

## Extracted Widgets

### 1. ProgressHeader

- Trigger: Readability
- Owns: No state
- Reports upward: Nothing

The header was extracted to keep the primary screen focused on
composition rather than the details of the header layout.

### 2. GameSearchField

- Trigger: Readability
- Owns: No application state
- Reports upward: Search query changes

The search field receives a controller and reports changes through
`onChanged`. The search query remains owned by the screen because the
game list depends on it.

### 3. GameList

- Trigger: Readability
- Owns: No application state
- Reports upward: Selected game

The list is responsible for displaying the collection of games and
forwarding game selection events to the parent.

### 4. GameCard

- Trigger: Reuse and readability
- Owns: No application state
- Reports upward: Game selection

The card represents the repeated visual structure of an individual
game. Keeping it as a separate widget allows the same structure to be
used for different games.

### 5. ProgressSummary

- Trigger: Readability
- Owns: No application state
- Reports upward: Nothing

The summary displays aggregated progress information calculated by the
screen.

## State Ownership

The primary screen owns the game list and search query. Child widgets
receive the data they need through constructor parameters and report
user interactions through callbacks.

This keeps shared state above the widgets that depend on it and
prevents sibling widgets from having to communicate directly.