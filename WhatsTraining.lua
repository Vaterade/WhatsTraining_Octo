setfenv(1, WhatsTraining)
WhatsTraining = {
  initialized = false
}

function WhatsTraining:Initialise()
  local name = UnitName("player")
  if name then
    PlayerData:SetName(name)
  end
  local localisedClass, englishClass = UnitClass("player")
  local localisedRace, englishRace = UnitRace("player")
  PlayerData:SetClass(englishClass)
  PlayerData:SetRace(englishRace)
  PlayerData:SetLevel(UnitLevel("player"))
  PlayerData:SetSpellsByLevel(ClassSpellsByLevel[PlayerData.class])

  local overridenSpells = OverridenSpells[PlayerData.class]
  if (overridenSpells) then
    PlayerData:SetOverriddenSpells(overridenSpells)
  end

  PlayerData:ApplyTrainerSpells()
  PlayerData:GetKnownSpells()
  PlayerData:GetAvailableSpells()

  WhatsTrainingUI:Initialize()

  WhatsTrainingUI:SetItems(PlayerData.spellsByCategory)

  WhatsTraining.initialized = true
end

function WhatsTraining:Refresh()
  if WhatsTraining.initialized == false then
    return
  end
  PlayerData:SetLevel(UnitLevel("player"))
  PlayerData:GetKnownSpells()
  PlayerData:GetAvailableSpells()
  
  WhatsTrainingUI:ClearItems()
  WhatsTrainingUI:SetItems(PlayerData.spellsByCategory)
  WhatsTrainingUI:Update()
end

local function OnEvent()
  if event == "PLAYER_ENTERING_WORLD" then
    -- This fires on every loading screen, but the frames must only be built once
    if WhatsTraining.initialized then
      WhatsTraining:Refresh()
    else
      WhatsTraining:Initialise()
    end
  elseif event == "TRAINER_SHOW" then
    if WhatsTraining.initialized and TrainerData:Scan() then
      PlayerData:ApplyTrainerSpells()
      WhatsTraining:Refresh()
    end
  elseif event == "PLAYER_LEVEL_UP" then
    WhatsTraining:Refresh()
  elseif event == "SPELLS_CHANGED" then
    WhatsTraining:Refresh()
  end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_LEVEL_UP")
f:RegisterEvent("SPELLS_CHANGED")
f:RegisterEvent("TRAINER_SHOW")
f:SetScript("OnEvent", OnEvent)
