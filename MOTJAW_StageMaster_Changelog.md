# MOTJAW StageMaster — Changelog
All notable changes to this project will be documented in this file.

The format is based on [Semantic Versioning](httpssemver.org).

---

## [2.1.1] — 2026-04-23
### Fixed
- Removed setlist loop‑blink animation (redundant with Loop button state).
- Cleaned up CSS and JS related to `.looping` class.
- Ensured PlayStop button always reflects REAPER transport state in both modes.

### Improved
- Setlist Mode UI stability and scroll behavior.
- Minor code cleanup for readability and maintainability.

---

## [2.1.0] — 2026-04-23
### Added
- Setlist Mode (new major feature)
  - Displays full setlist from REAPER project tabs.
  - Auto‑centers on the currently playing song.
  - Highlights the active song.
  - Looping song previously had a blinking overlay (removed in 2.1.1).
  - PlayLoop buttons become status‑only (no actions).
  - Footer remains fully functional (progress bar, triangle, region colors, timers).

- Mode Toggle UI
  - Vocal Mode ↔ Setlist Mode switch.
  - Visual state indicators for active mode.

### Improved
- Unified footer layout across both modes.
- More robust JSON handling for setlist data.
- Better separation of UI logic between modes.

---

## [2.0.0] — 2026-04-23
### Added
- Major architecture update introducing multi‑mode support.
- New JSON fields from Lua backend
  - `setlist` array
  - Sorted regions and lyrics
  - Cleaned project name extraction

### Improved
- Region color rendering.
- Progress bar and playhead accuracy.
- Next‑track detection logic.

---

## [1.1.0] — 2026-04-22
### Added
- Region color support.
- Progress bar enhancements.
- Playhead triangle cursor.
- Time remaining warnings.

---

## [1.0.0] — 2026-04-22
### Initial Release
- Vocal Mode with scrolling lyrics.
- Basic footer with time remaining and next track.
- Transport and Loop controls.
- JSON‑driven lyric and region updates.
