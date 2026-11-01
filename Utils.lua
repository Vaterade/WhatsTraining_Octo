setfenv(1, WhatsTraining)
Utils = {}

--- Filters the spellsByLevel table with the given predicate
---@param spellsByLevel SpellsByLevel
---@param predicate fun(spell: Spell): boolean
---@return SpellsByLevel
local function filter(spellsByLevel, predicate)
  local output = {}
  for level, spells in pairs(spellsByLevel) do
    output[level] = {}
    for _, spell in ipairs(spells) do
      if (predicate(spell) == true) then
        tinsert(output[level], spell)
      end
    end
  end
  return output
end

function Utils.TableHasValue(tab, val)
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end

  return false
end

local RACE_ALIASES = { SCOURGE = "UNDEAD", BLOODELF = "HIGHELF" }

--- Returns the table of spells filtered by the given race
---@param spellsByLevel SpellsByLevel
---@param playerRace string
---@return SpellsByLevel
function Utils.FilterByRace(spellsByLevel, playerRace)
  -- UnitRace gives "Gnome", "NightElf" and "Scourge"; the class data uses "GNOME", "NIGHTELF" and "UNDEAD"
  local race = RACE_ALIASES[strupper(playerRace)] or strupper(playerRace)

  return filter(spellsByLevel, function(spell)
    if (spell.race == nil and spell.races == nil) then
      return true
    end

    if (spell.races == nil) then
      return strupper(spell.race) == race
    end

    for _, allowedRace in ipairs(spell.races) do
      if strupper(allowedRace) == race then
        return true
      end
    end
    return false
  end)
end

--- Removes spells that the client has no record of. Needs ClassicAPI; without it nothing is removed.
---@param spellsByLevel SpellsByLevel
---@return SpellsByLevel
function Utils.FilterMissingFromClient(spellsByLevel)
  if not (C_Spell and C_Spell.DoesSpellExist) then
    return spellsByLevel
  end

  return filter(spellsByLevel, function(spell)
    return C_Spell.DoesSpellExist(spell.id) == true
  end)
end

--- Replaces a spell's name, rank, icon and level with the client's. Needs ClassicAPI;
--- without it, or where the client has no value, the class data stays.
---@param spell Spell
function Utils.ApplyClientSpellData(spell)
  if not (C_Spell and C_SpellBook) then
    return
  end

  spell.name = C_Spell.GetSpellName(spell.id) or spell.name
  spell.subText = C_Spell.GetSpellSubtext(spell.id) or ""
  spell.icon = C_Spell.GetSpellTexture(spell.id) or spell.icon

  local level = C_SpellBook.GetSpellLevelLearned(spell.id)
  if level and level > 0 then
    spell.level = level
  end
end

--- Returns the table of spells that has level requirements less than or equal the given level
---@param spellsByLevel SpellsByLevel
---@param playerLevel integer
---@return SpellsByLevel
function Utils.FilterByLevel(spellsByLevel, playerLevel)
  return filter(spellsByLevel, function(spell)
    return (spell.level <= playerLevel)
  end)
end

--- Splits the given string by the given separator
---@param input string
---@param separator? string
function Utils.SplitString(input, separator)
  if separator == nil then
    separator = "%s"
  end
  Utils.log(string.gmatch(input, separator))
  local t = {}
  -- for str in string.gmatch(input, separator) do
  --   table.insert(t, str)
  -- end
  return t
end

--- Returns the rank number of a given rankText
---@param rankText? string
---@return integer?
function Utils.GetRankNumber(rankText)
  if rankText == nil or rankText == "" then
    return 0 -- Lua arrays start from 1.
  end

  local _, rankNumber = Utils.SplitString(rankText)

  return tonumber(rankNumber)
end

function Utils.log(msg)
  DEFAULT_CHAT_FRAME:AddMessage(msg)
end

---Returns the spell key for a given name and rank
---@param name string
---@param rank string|nil
---@return string
function Utils.getSpellWithRankKey(name, rank)
  local spellNameKey = name
  if (rank ~= "" and rank ~= nil) then
    spellNameKey = spellNameKey .. "-" .. rank
  end

  return spellNameKey
end

---Returns the length of a table
---@param t table
---@return integer
function Utils.tableLength(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end