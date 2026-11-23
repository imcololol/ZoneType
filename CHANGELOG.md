# Changelog

## v0.2.0

- New: when you enter a new zone, its area types pop up on screen under the zone name, in the same style as the game's zone text (Grassland in green, Desert in gold, Wasteland in brown, Haunted in purple). Several types share one line.
- New: ZoneType has its own map-pin icon (minimap button and addon list).
- New: minimap button. Left-click unlocks the on-screen text so you can move it (left-click again to lock), right-click opens settings, drag to move the button.
- New: settings (Esc > Options > AddOns > ZoneType, or right-click the minimap button): turn the pop-up on/off, text size, which area types pop up (Grassland, Desert, Wasteland and Haunted by default), the chat message, and the minimap button.
- New: while unlocked, drag the blue box or type an exact X / Y position under it. Center puts it in the middle left-to-right; Lock saves it.
- New commands: `/zt settings`, `/zt unlock`, `/zt lock`, `/zt pos <x> <y>`, `/zt pos center`, `/zt resetpos`, `/zt flash`, `/zt flash test`, `/zt minimap`.

## v0.1.1

- Fix: in towns inside a zone (like Everlook in Winterspring), the area types now show on one line instead of several indented lines.

## v0.1.0

- First version. `/zt` shows the area types (Desert, Swamp, Haunted and more) for where you're standing.
- Shows a message when you move into a place with different area types (`/zt auto` turns it off).
- `/zt list <type>` lists every place of a type.
- `/zt where` and `/zt test` for bug reports and checks.
