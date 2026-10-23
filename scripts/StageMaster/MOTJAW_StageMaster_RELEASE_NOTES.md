# MOTJAW StageMaster — Release Notes
Version: 2.1.1  
Release Date: 2026‑04‑23

MOTJAW StageMaster v2.1.1 is a stability and polish update to the new Setlist Mode introduced in v2.1.0. This release improves UI clarity, removes redundant animations, and ensures consistent behavior across both Vocal and Setlist modes.

---

## 🎤 What’s New
### ✔ Unified Versioning
Both the HTML/JS frontend and the Lua backend now share the same version number (2.1.1), ensuring full compatibility.

---

## 🛠 Improvements
### Setlist Mode
- Auto‑centering of the active song is smoother and more reliable.
- Highlighting of the current song is clearer and more consistent.
- Looping indicator now relies solely on the Loop button (blink removed).

### Transport Controls
- Play/Stop button now always reflects REAPER’s actual transport state.
- Loop button clearly shows ON/OFF state in both modes.

### Footer
- Progress bar, region colors, playhead triangle, and timers remain fully functional in both modes.

---

## 🐞 Fixes
- Removed the blinking overlay on the current setlist item (redundant with Loop button).
- Cleaned up leftover CSS and JS related to the `.looping` class.
- Minor layout and scroll behavior fixes.

---

## 📦 Included Components
- Updated HTML/JS interface (Vocal + Setlist modes)
- Updated Lua metadata backend (JSON v2.1 schema)
- Unified versioning across all components

---

## 🚀 Recommended Update Path
1. Replace your existing HTML file with the new v2.1.1 version.  
2. Replace your Lua background script with the v2.1.1 version.  
3. Reload REAPER project tabs to refresh metadata.  

---

## 🎯 Compatibility
- REAPER 6.x and 7.x  
- Windows 10/11  
- MOTJAW StageMaster Lua Script v2.1.1  
- MOTJAW StageMaster HTML Interface v2.1.1  

---

## ❤️ Special Thanks
Thanks to Tommy for driving the vision, testing live, and pushing MOTJAW StageMaster to pro‑level performance.
