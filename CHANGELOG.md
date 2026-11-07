# Changelog

Each release gets a section here, newest first. The release workflow copies the section for
the version in `WhatsTraining_Octo.toc` into the GitHub release notes, so write it for players.

Versions follow [semantic versioning](https://semver.org/): a fix raises the last number, a
new feature the middle one. While the first number is 0 the addon isn't considered stable yet.

## [1.1.0] - 2026-11-06

The first OctoWoW release, forked from
[WhatsTraining_Turtle](https://github.com/FrancisEgan/WhatsTraining_Turtle) 1.0.8. Older
versions are in `changes.log` and that repository's history.

### Changed
- Renamed to WhatsTraining_Octo. If you had WhatsTraining_Turtle installed, remove that folder
  so the two don't both load.
- With ClassicAPI, known spells are checked with `IsPlayerSpell`, and names, ranks, icons and
  levels come from the client.
- Each class trainer's list is saved per class and race. Its levels replace the built-in
  ones, spells only the trainer lists are added, and spells no trainer has listed move to a
  new "Not seen at a trainer" section.
- The window now follows the spellbook's frame layer, so it no longer draws behind it when
  another addon raises the spellbook.

### Fixed
- Removed spells trainers don't teach (talent effects, other spells' effects, old records),
  which showed as available but couldn't be learned.
- Corrected Aspect of the Viper, Lightwell, Frostbolt rank 2, and the levels of Expose Armor
  and Shred rank 6; audited class prerequisites.
- Race-locked spells now match races correctly (`Gnome`/`GNOME`, `Scourge`/`UNDEAD`).
- Grace of the Sunwell only shows for High Elves.
- Later ranks of talent spells need the previous rank, instead of showing as missing a talent.

[1.1.0]: https://github.com/Vaterade/WhatsTraining_Octo/releases/tag/v1.1.0
