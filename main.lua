SMODS.Atlas({
  key = "poke_wow2",
  path = "poke_wow2.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "poke_shiny2",
  path = "poke_shiny2.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "poke_wow3",
  path = "poke_wow3.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "poke_shiny3",
  path = "poke_shiny3.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "poke_wow4",
  path = "poke_wow4.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "poke_shiny4",
  path = "poke_shiny4.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "poke_wow5",
  path = "poke_wow5.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "poke_shiny5",
  path = "poke_shiny5.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "poke_wow6",
  path = "poke_wow6.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "poke_shiny6",
  path = "poke_shiny6.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "poke_wow8",
  path = "poke_wow8.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "poke_shiny8",
  path = "poke_shiny8.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "poke_wow9",
  path = "poke_wow9.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "poke_shiny9",
  path = "poke_shiny9.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "poke_wowmega",
  path = "poke_wowmega.png",
  px = 71,
  py = 95
}):register()

SMODS.Atlas({
  key = "poke_shinymega",
  path = "poke_shinymega.png",
  px = 71,
  py = 95
}):register()

table.insert(pokermon.family, {"cottonee", "whimsicott"})
table.insert(pokermon.family, {"carvanha", "sharpedo", "mega_sharpedo"})
table.insert(pokermon.family, {"noibat", "noivern"})

wowzas_config = SMODS.current_mod.config
mod_dir = ''..SMODS.current_mod.path
if (SMODS.Mods["Pokermon"] or {}).can_load then
    pokermon_config = SMODS.Mods["Pokermon"].config
end

SMODS.current_mod.config_tab = function() 
    return {
        n = G.UIT.ROOT,
        config = {
            align = "cm",
            padding = 0.05,
            colour = G.C.CLEAR,
        },
        nodes = {
            create_toggle({
                label = "Allow Custom Jokers?",
                ref_table = wowzas_config,
                ref_value = "customJokers",
            }),
        },
    }
end

--Load Joker Display if the mod is enabled
if (SMODS.Mods["JokerDisplay"] or {}).can_load then
  local jokerdisplays = NFS.getDirectoryItems(mod_dir.."jokerdisplay")

  for _, file in ipairs(jokerdisplays) do
    sendDebugMessage ("The file is: "..file)
    local helper, load_error = SMODS.load_file("jokerdisplay/"..file)
    if load_error then
      sendDebugMessage ("The error is: "..load_error)
    else
      helper()
    end
  end
end



-- Get mod path and load other files
mod_dir = ''..SMODS.current_mod.path
if (SMODS.Mods["Pokermon"] or {}).can_load then
    pokermon_config = SMODS.Mods["Pokermon"].config
end

print("DEBUG")

--Load pokemon file
local pfiles = NFS.getDirectoryItems(mod_dir.."pokemon")
if (SMODS.Mods["Pokermon"] or {}).can_load and SMODS.Mods["Pokermon"] and wowzas_config.customJokers then
  for _, file in ipairs(pfiles) do
    sendDebugMessage ("The file is: "..file)
    local pokemon, load_error = SMODS.load_file("pokemon/"..file)
    if load_error then
      sendDebugMessage ("The error is: "..load_error)
    else
      local curr_pokemon = pokemon()
      if curr_pokemon.init then curr_pokemon:init() end
      
      if curr_pokemon.list and #curr_pokemon.list > 0 then
        for i, item in ipairs(curr_pokemon.list) do
          if (pokermon_config.jokers_only and not item.joblacklist) or not pokermon_config.jokers_only  then
            item.discovered = true
            if not item.key then
              item.key = item.name
            end
            if not pokermon_config.no_evos and not item.custom_pool_func then
              item.in_pool = function(self)
                return pokemon_in_pool(self)
              end
            end
            if not item.config then
              item.config = {}
            end
            if item.ptype then
              if item.config and item.config.extra then
                item.config.extra.ptype = item.ptype
              elseif item.config then
                item.config.extra = {ptype = item.ptype}
              end
            end
            if item.item_req then
              if item.config and item.config.extra then
                item.config.extra.item_req = item.item_req
              elseif item.config then
                item.config.extra = {item_req = item.item_req}
              end
            end
            if item.evo_list then
              if item.config and item.config.extra then
                item.config.extra.evo_list = item.evo_list
              elseif item.config then
                item.config.extra = {item_req = item.evo_list}
              end
            end
            if pokermon_config.jokers_only and item.rarity == "poke_safari" then
              item.rarity = 3
            end
            item.discovered = not pokermon_config.pokemon_discovery 
            SMODS.Joker(item)
          end
        end
      end
    end
  end
end 



--Load Debuff logic
local sprite, load_error = SMODS.load_file("functions/functions.lua")
if load_error then
  sendDebugMessage ("The error is: "..load_error)
else
  sprite()
end

if (SMODS.Mods["Pokermon"] or {}).can_load and SMODS.Mods["Pokermon"] and not pokermon_config.jokers_only then
  if (SMODS.Mods["CardSleeves"] or {}).can_load then
    --Load Sleeves
    local sleeves = NFS.getDirectoryItems(mod_dir.."sleeves")

    for _, file in ipairs(sleeves) do
      sendDebugMessage ("the file is: "..file)
      local sleeve, load_error = SMODS.load_file("sleeves/"..file)
      if load_error then
        sendDebugMessage("The error is: "..load_error)
      else
        local curr_sleeve = sleeve()
        if curr_sleeve.init then curr_sleeve.init() end
        
        for i,item in ipairs (curr_sleeve.list) do
          CardSleeves.Sleeve(item)
        end
      end
    end
  end
end