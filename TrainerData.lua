setfenv(1, WhatsTraining)

-- What trainers actually offer is decided by the server and isn't in the client.
-- The trainer window is the only place to read it, so each list is saved when seen.
-- Lists are shared by characters of the same class and race, and merged rather than
-- replaced, because one trainer may not teach everything (mage portal trainers, for example).
TrainerData = {}

-- Fewer matches than this means it's not a class trainer (pet trainer, weapon master)
local MIN_CLASS_SPELL_MATCHES = 5
local SERVICE_TYPES = { "available", "unavailable", "used" }

---Reads every row of the open trainer window, then leaves the window as it was
---@return table[]
local function ReadServices()
  local collapsed = {}
  for i = 1, GetNumTrainerServices() do
    local name, _, serviceType, isExpanded = GetTrainerServiceInfo(i)
    if serviceType == "header" and not isExpanded then
      collapsed[name] = true
    end
  end

  local filters = {}
  for _, serviceType in ipairs(SERVICE_TYPES) do
    filters[serviceType] = GetTrainerServiceTypeFilter(serviceType)
    SetTrainerServiceTypeFilter(serviceType, 1)
  end
  ExpandTrainerSkillLine(0)

  local rows = {}
  local count = GetNumTrainerServices()
  local school
  for i = 1, count do
    local name, subText, serviceType = GetTrainerServiceInfo(i)
    if serviceType == "header" then
      school = name
    elseif name then
      tinsert(rows, {
        name = name,
        subText = subText or "",
        school = school,
        icon = GetTrainerServiceIcon(i),
        level = GetTrainerServiceLevelReq(i),
      })
    end
  end

  -- From the end, so that collapsing a row doesn't move the ones still to be checked
  for i = count, 1, -1 do
    local name, _, serviceType = GetTrainerServiceInfo(i)
    if serviceType == "header" and collapsed[name] then
      CollapseTrainerSkillLine(i)
    end
  end
  for _, serviceType in ipairs(SERVICE_TYPES) do
    SetTrainerServiceTypeFilter(serviceType, filters[serviceType] and 1 or 0)
  end

  return rows
end

---Returns the saved spells for a class and race, or nil if no trainer has been seen
---@param class string
---@param race string
---@return table<string, table>?
function TrainerData:Get(class, race)
  local db = _G.WhatsTrainingDB
  return db and db.trainerSpells and db.trainerSpells[class .. ":" .. race]
end

---Saves the open trainer's list if it's a trainer for the player's class
---@return boolean saved
function TrainerData:Scan()
  if IsTradeskillTrainer() then
    return false
  end

  local rows = ReadServices()
  local matches = 0
  for _, row in ipairs(rows) do
    if Utils.findBySpellKey(PlayerData.spellsByNameAndRank, row.name, row.subText) then
      matches = matches + 1
    end
  end
  if matches < MIN_CLASS_SPELL_MATCHES then
    return false
  end

  local db = _G.WhatsTrainingDB
  if not db then
    db = {}
    _G.WhatsTrainingDB = db
  end
  db.trainerSpells = db.trainerSpells or {}

  local key = PlayerData.class .. ":" .. PlayerData.race
  db.trainerSpells[key] = db.trainerSpells[key] or {}
  for _, row in ipairs(rows) do
    db.trainerSpells[key][Utils.getSpellWithRankKey(row.name, row.subText)] = row
  end
  return true
end
