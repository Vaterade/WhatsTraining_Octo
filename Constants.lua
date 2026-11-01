setfenv(1, WhatsTraining)

local COMINGSOON_FONT_COLOR_CODE = "|cff82c5ff"
local MISSINGTALENT_FONT_COLOR_CODE = "|cffffffff"
local ORANGE_FONT_COLOR_CODE = "|cffff8040"
local PET_FONT_COLOR_CODE = "|cffffffff"
local NOTOFFERED_FONT_COLOR_CODE = "|cffffff99"


---@enum SpellCategories
SpellCategories = {
  AVAILABLE = "available",
  MISSING_REQS = "missingReqs",
  NEXT_LEVEL = "nextLevel",
  NOT_LEVEL = "notLevel",
  NOT_OFFERED = "notOffered",
  MISSING_TALENT = "missingTalent",
  IGNORED = "ignored",
  KNOWN = "known",
  KNOWN_PET = "knownPet",
  PET = "pet"
}

---@class SpellCategoryHeader
---@field name string
---@field key SpellCategories
---@field color? string
---@field hideLevel? boolean
---@field showSpellSchoolHeader? boolean

---@type SpellCategoryHeader[]
SpellCategoryHeaders = { {
  name = "Available now",
  color = GREEN_FONT_COLOR_CODE,
  hideLevel = true,
  key = SpellCategories.AVAILABLE,
  showSpellSchoolHeader = false
}, {
  name = "Available but missing requirements",
  color = ORANGE_FONT_COLOR_CODE,
  key = SpellCategories.MISSING_REQS
}, {
  name = "Coming soon",
  color = COMINGSOON_FONT_COLOR_CODE,
  key = SpellCategories.NEXT_LEVEL
}, {
  name = "Not yet available",
  color = RED_FONT_COLOR_CODE,
  key = SpellCategories.NOT_LEVEL
}, {
  name = "Not seen at a trainer",
  color = NOTOFFERED_FONT_COLOR_CODE,
  key = SpellCategories.NOT_OFFERED
}, {
  name = "Pet Abilities",
  color = PET_FONT_COLOR_CODE,
  key = SpellCategories.PET
}, {
  name = "Missing required talent",
  color = MISSINGTALENT_FONT_COLOR_CODE,
  key = SpellCategories.MISSING_TALENT,
  hideLevel = true,
}, {
  name = "Ignored",
  color = LIGHTYELLOW_FONT_COLOR_CODE,
  -- costFormat = WT.L.TOTALSAVINGS_FORMAT,
  key = SpellCategories.IGNORED,
}, {
  name = "Known",
  color = GRAY_FONT_COLOR_CODE,
  hideLevel = true,
  key = SpellCategories.KNOWN,
}, {
  name = "Known (Pet)",
  color = GRAY_FONT_COLOR_CODE,
  hideLevel = true,
  key = SpellCategories.KNOWN_PET,
} }