# Changelog

## v0.2.0

- New: when you enter a Grassland, Desert, Wasteland or Haunted area, it shows on screen under the zone name in the same style as the game's zone text (Grassland in green, Desert in gold, Wasteland in brown, Haunted in purple). `/zt flash` turns it off, `/zt flash test` shows a sample.
- New: `/zt unlock` shows a box you can drag to move the on-screen text anywhere. `/zt lock` when done, `/zt resetpos` to put it back under the zone name. The box fits the text.

## v0.1.1

- Fix: in towns inside a zone (like Everlook in Winterspring), the area types now show on one line instead of several indented lines.

## v0.1.0

- First version. `/zt` shows the area types (Desert, Swamp, Haunted and more) for where you're standing.
- Shows a message when you move into a place with different area types (`/zt auto` turns it off).
- `/zt list <type>` lists every place of a type.
- `/zt where` and `/zt test` for bug reports and checks.
