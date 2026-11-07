# Divehi

An iPad-first app that helps a toddler learn the Thaana (Dhivehi) alphabet. All 24 letters show as tiles in a grid. Tap a letter to hear it.

## Built for small hands

- **Plays on finger down.** It doesn't wait for the finger to lift.
- **Handles more than one finger.** Every finger is tracked separately, so a second finger, a palm or a drag doesn't block a tap. Sliding a finger onto another tile plays that tile.
- **Responds instantly.** All clips are decoded into memory at launch and played through a running audio engine with a 5 ms buffer. A new tap cuts off the previous sound, so you always hear the letter that was just touched.
- **Doesn't scroll.** All 24 tiles fit on screen in any orientation, so a swipe can't move the page.
- **Taps in the gaps still count.** A tap between tiles plays the nearest one.
- **Is hard to leave by accident.** The status bar is hidden, edge swipes need a second swipe, and Split View is off. The sound plays even when the silent switch is on.
- **Shows progress.** Each tile's bar fills after 5 taps and turns gold when full. Hold the title for 3 seconds to reset progress.

## Run it

1. Open `Divehi.xcodeproj` in Xcode 16 or later.
2. Under **Signing & Capabilities**, choose your Apple ID team.
3. Plug in the iPad and press Run.

If the project won't open, run `brew install xcodegen && xcodegen` in this folder to generate a new project.

**Tip:** Turn on **Guided Access** (Settings › Accessibility › Guided Access) and triple-click the side button inside the app. This locks the iPad to the app.

## Re-record the letters

Record all 24 letters in alphabet order, with a short pause between each one. Then run:

```
tools/split_recording.sh my-recording.m4a
```

This creates `Divehi/Sounds/letter_01.caf` … `letter_24.caf`. The script trims each clip and evens out the volume. Letter order and labels are in `Divehi/Letter.swift`.

## Files

| File | Purpose |
|---|---|
| `Letter.swift` | The 24 letters, their names and the short sounds shown on the tiles |
| `SoundPlayer.swift` | Low-latency audio engine |
| `TouchSurface.swift` | Multi-touch layer that triggers on finger down |
| `GridLayout.swift` | Fits the tiles on screen, right to left |
| `LetterTile.swift` | Duolingo-style tile and progress bar |
| `AlphabetModel.swift` | Pressed state and saved tap counts |
