# ZoneType

A World of Warcraft: Forever addon that tells you which **area types** your current zone counts as: Desert, Swamp, Forest & Grassland, Haunted and the rest. Many Forever items get a bonus in a certain kind of area, and the game's tooltips name only the area type, never the zones. ZoneType fills that gap.

## Features

- Type `/zt` to see what the place you're standing in counts as
- Shows every type a place has (Tirisfal Glades is Forest & Grassland, Wasteland and Haunted)
- Knows towns and cities inside zones (Booty Bay, Gadgetzan, Everlook) as well as dungeons, raids and battlegrounds
- Flashes **Grassland** (green) or **Desert** (gold) on screen under the zone name when you enter one
- Prints a message when you move into a place with different area types (you can turn this off)
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

## Commands

| Command | What it does |
|---|---|
| `/zt` (or `/zonetype`) | Show the area types for where you are |
| `/zt list [type]` | List every place of a type (e.g. `/zt list desert`); with no type, lists the types |
| `/zt flash` | Turn the on-screen Grassland/Desert flash on or off |
| `/zt flash test` | Show a sample flash |
| `/zt auto` | Turn the zone-change message on or off |
| `/zt where` | Show what the game reports about your location (for bug reports) |
| `/zt test` | Check that the addon is working |
| `/zt help` | List the commands |

## Reporting bugs

Open an [issue](../../issues) with what happened. Include the output of `/zt where` from the spot where it went wrong.
