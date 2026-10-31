# Spell chain audit

Run `node WhatsTraining_Octo/tests/check-chains.cjs` from the AddOns directory.
The test reads the class data directly and checks all nine classes for missing
ranks, prerequisite cycles, links to anything other than the preceding rank,
level and racial conflicts, and incomplete or invalid overwritten-rank lists.
Mind-numbing Poison's II/III name suffixes belong to the same rank chain.
Multiple IDs sharing a spell name and rank remain separate records; they now
require the preceding rank rather than another ID of their own rank. The addon
already recognizes every matching ID when it scans the spellbook.

The October 5, 2026 audit passes for 1,461 spell records, 269 ranked spell
families, 980 prerequisite links, and 213 overwritten-rank lists.

Changes made in this audit:

- Corrected 38 prerequisite records across Druid, Hunter, Paladin, Priest,
  Rogue, Shaman, and Warlock. Mage's earlier Frostbolt/Fireball corrections
  were checked again.
- Added missing Holy Light rank 5, Curse of Agony rank 2, Judgement of the
  Crusader rank 1, and Steady Shot ranks 1–5. IDs, names, ranks, and levels
  were checked against `DBFilesClient\Spell.dbc` extracted read-only from
  the installed client's `Data\patch-5.mpq`.
- Removed four unreachable override entries whose source IDs were absent
  from the class lists: Hunter 1528, Paladin 19998/21084, Warrior 7377.
- Corrected Slam's rank 2–5 override lists to remove self-references and
  repeated IDs while retaining every earlier rank.

Explicit exceptions and limits:

- Dire Bear Form replaces Bear Form; this is an intentional cross-name
  override, not a ranked chain.
- This checks the addon data, not live server trainer offerings. The client
  also contains old or deprecated spell records, so their presence alone
  does not establish that a trainer currently teaches them.

## October 31, 2026 cleanup

The audit now passes for 1,406 spell records, 253 ranked spell families, 945
prerequisite links, and 211 overwritten-rank lists. Entries were compared with
the client's `Spell.dbc`, `SkillLineAbility.dbc` and `Talent.dbc`.

- Removed effects of other spells: Immolation and Explosive Trap Effect,
  Pounce Bleed, Hellfire Effect, Ritual of Doom Effect, Moonkin Aura, and
  Judgement of the Crusader, Wisdom, Justice and Light.
- Removed talent spell effects: Holy Shock (25912/25911/25902) and Eye for an
  Eye (25997).
- Removed spells whose first rank has no teaching spell or talent of that name
  in the client: Wyvern Sting, Counterattack, Power Infusion, Mana Tide Totem
  and Dark Pact. Their later ranks went too, as with other talent spells. The
  server's trainer lists aren't in the client, so this one is inferred.
- Removed old records: `zzOLD Pummel` (6554), Lightwell Renew (7001) and the
  deprecated Lightwell ranks (27870/27871/51458). Lightwell (724) is now
  unranked, as in the client.
- 45651 is now Aspect of the Viper at level 56, not Aspect of the Fox at level
  4. It keeps the old icon, which wasn't checked against the client.
- Moved Expose Armor ranks 1–5 to levels 10/22/32/42/52 and Shred rank 6 to
  level 60, matching `BaseLevel` in the client.
