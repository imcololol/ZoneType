<img src="media/logo.png" alt="ZoneType logo" width="128" align="right">

# ZoneType

A World of Warcraft: Forever addon that tells you which **area types** your current zone counts as: Desert, Swamp, Forest & Grassland, Haunted and the rest. Many Forever items get a bonus in a certain kind of area, and the game's tooltips name only the area type, never the zones. ZoneType fills that gap.

## Features

- Type `/zt` to see what the place you're standing in counts as
- Shows every type a place has (Tirisfal Glades is Forest & Grassland, Wasteland and Haunted)
- When you enter a new zone, its area types pop up on screen under the zone name, in the game's own zone-text style (Grassland green, Desert gold, Wasteland brown, Haunted purple)
- Pick which area types pop up, and the text size, in settings
- Move the pop-up anywhere: left-click the minimap button, then drag the blue box or type an exact X / Y
- Knows towns and cities inside zones (Booty Bay, Gadgetzan, Everlook) as well as dungeons, raids and battlegrounds
- Optional chat message when you move into a place with different area types
- `/zt list desert` lists every place of a type, handy for planning where to use an item

The zone lists come from the area lists in the Forever 1.60.1 game files. **Volcanic** has no list in the game files yet, so ZoneType can't tell you about it.

> Zone names are matched in English for now. On other game languages, `/zt` may say "no area type known".

## Install

**WowUp:** choose *Install from URL* and paste this repository's GitHub URL.

**Manual:** download `ZoneType-<version>-forever.zip` from [Releases](../../releases) and extract it into:

```
World of Warcraft\_forever_\Interface\AddOns\
```

You should end up with `AddOns\ZoneType\ZoneType.toc`.

## Minimap button

- **Left-click:** unlock the on-screen text to move it (left-click again, or click **Lock**, when done)
- **Right-click:** settings
- **Drag:** move the button around the minimap

## Settings

Esc > Options > AddOns > ZoneType (or right-click the minimap button):

- Pop up area types on screen (on/off)
- Text size
- Which area types pop up (Grassland, Desert, Wasteland and Haunted are on by default)
- Chat message when the area type changes
- Show minimap button

## Commands

| Command | What it does |
|---|---|
| `/zt` (or `/zonetype`) | Show the area types for where you are |
| `/zt settings` | Open settings |
| `/zt unlock` / `/zt lock` | Move the on-screen text: drag the blue box or type X / Y under it |
| `/zt pos <x> <y>` | Place the on-screen text by numbers: pixels from the middle of the screen, + is right/up (e.g. `/zt pos 0 200`). `/zt pos` alone shows where it is now |
| `/zt pos center` | Center the on-screen text left-to-right, keeping its height |
| `/zt resetpos` | Put the on-screen text back under the zone name |
| `/zt flash` | Turn the on-screen pop-up on or off |
| `/zt flash test` | Show a sample pop-up |
| `/zt auto` | Turn the zone-change chat message on or off |
| `/zt minimap` | Show or hide the minimap button |
| `/zt list [type]` | List every place of a type (e.g. `/zt list desert`); with no type, lists the types |
| `/zt where` | Show what the game reports about your location (for bug reports) |
| `/zt test` | Check that the addon is working |
| `/zt help` | List the commands |

## Reporting bugs

Open an [issue](../../issues) with what happened. Include the output of `/zt where` from the spot where it went wrong.
