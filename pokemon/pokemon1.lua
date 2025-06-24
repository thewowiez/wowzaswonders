local carvanha = {
  name = "carvanha",
  pos = {x = 6, y = 6},
  config = { extra = {mult = 0, mult_mod = 7, eaten = 0}, evo_rqmt = 21},
  rarity = 1,
  cost = 4,
  stage = "Basic",
  atlas = "poke_wow3",
  ptype = "Water",
  blueprint_compat = true,
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.mult, center.ability.extra.mult_mod, center.ability.extra.eaten } }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.before and not context.blueprint then
      for k, v in ipairs(context.scoring_hand) do
        if v:get_id() == 14 and v:is_suit("Spades") and not v.debuff then
          card.ability.extra.eaten = card.ability.extra.eaten + 1
          card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
          v.carvanha_target = true
          G.E_MANAGER:add_event(Event({
            func = function()
              v:juice_up()
              return true
            end
          }))
        end
      end
    elseif context.cardarea == G.jokers and context.scoring_hand and context.joker_main then
      return {
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
        colour = G.C.MULT,
        mult_mod = card.ability.extra.mult
      }
    elseif context.destroying_card then
      local eat = context.destroying_card:get_id() == 14 and context.destroying_card:is_suit("Spades")
      return not context.blueprint and eat and context.destroying_card.carvanha_target
    end
    return scaling_evo(self, card, context, "j_poke_sharpedo", card.ability.extra.mult, self.config.evo_rqmt)
  end
}
-- Sharpedo 319
local sharpedo = {
  name = "sharpedo",
  pos = {x = 7, y = 6},
  config = { extra = {mult = 0, mult_mod = 10, eaten = 0}},
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  atlas = "poke_wow3",
  ptype = "Water",
  blueprint_compat = true,
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue+1] = {set = 'Other', key = 'mega_poke'}
    return { vars = { center.ability.extra.mult, center.ability.extra.mult_mod, center.ability.extra.Xmult, center.ability.extra.Xmult_mod, center.ability.extra.eaten } }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.before and not context.blueprint then
      for k, v in ipairs(context.scoring_hand) do
        if v:get_id() == 14 and not v.debuff then
          card.ability.extra.eaten = card.ability.extra.eaten + 1
          card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
          v.sharpedo_target = true
          G.E_MANAGER:add_event(Event({
            func = function()
              v:juice_up()
              return true
            end
          }))
        end
      end
    elseif context.cardarea == G.jokers and context.scoring_hand and context.joker_main then
      return {
        message = localize("wow_crunch_ex"),
        colour = G.C.MULT,
        mult_mod = card.ability.extra.mult
      }
    elseif context.destroying_card then
      local eat = context.destroying_card:get_id() == 14
      return not context.blueprint and eat and context.destroying_card.sharpedo_target
    end
  end,
  megas = {"mega_sharpedo"}
}
-- Mega Sharpedo 319-1
local mega_sharpedo = {
  name = "mega_sharpedo",
  pos = {x = 4, y = 4},
  soul_pos = {x = 5, y = 4},
  config = { extra = {mult = 0, mult_mod = 10, Xmult = 1, Xmult_mod = 0.15, eaten = 0}},
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  atlas = "poke_wowmega",
  ptype = "Water",
  blueprint_compat = true,
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.mult, center.ability.extra.mult_mod, center.ability.extra.Xmult, center.ability.extra.Xmult_mod, center.ability.extra.eaten } }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.before and not context.blueprint then
      for k, v in ipairs(context.scoring_hand) do
        if v:is_suit("Spades") and not v.debuff and not v.debuff then
          card.ability.extra.eaten = card.ability.extra.eaten + 1
          card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
          card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
          v.mega_sharpedo_target = true
          G.E_MANAGER:add_event(Event({
            func = function()
              v:juice_up()
              return true
            end
          }))
        end
      end
    elseif context.cardarea == G.jokers and context.scoring_hand and context.joker_main then
      return {
        message = localize("wow_crunch_ex"),
        colour = G.C.XMULT,
        mult_mod = card.ability.extra.mult,
        Xmult_mod = card.ability.extra.Xmult
      }
    elseif context.destroying_card then
      local eat = context.destroying_card:is_suit("Spades")
      return not context.blueprint and eat and context.destroying_card.mega_sharpedo_target
    end
  end
}
-- Cottonee 546
local cottonee = {
  name = "cottonee",
  pos = { x = 10, y = 3},
  config = {extra = {money = 0, money_mod = 0.5, mult = 3}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.c_poke_sunstone
    return {vars = {card.ability.extra.money, card.ability.extra.money_mod, card.ability.extra.mult}}
  end,
  rarity = 1,
  cost = 5,
  item_req = "sunstone",
  stage = "Basic",
  ptype = "Grass",
  atlas = "poke_wow5",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and not context.end_of_round and context.cardarea == G.play then
      local earned = ease_poke_dollars(card, "cottonee", card.ability.extra.money_mod, true)
      return {
        dollars = earned,
        card = card
      }
    end
    if context.setting_blind then
      card:juice_up()
      local back_to_zero = 0
      if (SMODS.Mods["Talisman"] or {}).can_load then
        back_to_zero = to_number(-G.GAME.dollars)
      else
        back_to_zero = -G.GAME.dollars
      end
      ease_dollars(back_to_zero, true)
    end
    return item_evo(self, card, context, "j_poke_whimsicott")
  end,
}
-- Whimsicott 547
local whimsicott = {
  name = "whimsicott",
  pos = { x = 11, y = 3 },
  config = {extra = {money = 0.75, mult = 3}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return{vars = {card.ability.extra.money, card.ability.extra.mult}}
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "One",
  ptype = "Grass",
  atlas = "poke_wow5",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and not context.end_of_round and context.cardarea == G.play then
      local earned = ease_poke_dollars(card, "whimsicott", card.ability.extra.money, true)
      return {
        dollars = earned,
        card = card
      }
    end
    if context.joker_main then
      return {
        message = localize("wow_tailwind_ex"),
        colour = G.C.MULT,
        mult_mod = card.ability.extra.mult * #G.jokers.cards
      }
    end
  end,
}
-- Noibat 714
local noibat = {
  name = "noibat",
  pos = {x = 8, y = 4},
  config = {extra = {retriggers = 1, chips = 10, rounds = 6}},
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return{vars = {center.ability.extra.retriggers, center.ability.extra.chips, center.ability.extra.rounds}}
  end,
  rarity = 1,
  cost = 4,
  stage = "Basic",
  ptype = "Dragon",
  atlas = "poke_wow6",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and not context.end_of_round and context.cardarea == G.play then
      if context.other_card:get_id() == 2 or context.other_card:get_id() == 4 then
        return{
          chips = card.ability.extra.chips,
          card = card
        }
      end
    end
    if context.repetition and not context.end_of_round and context.cardarea == G.play then
      if context.other_card:get_id() == 2 or context.other_card:get_id() == 4 then
        return{
          message = localize('k_again_ex'),
          repetitions = card.ability.extra.retriggers,
          card = card
        }
      end
    end
    return level_evo(self, card, context, "j_poke_noivern")
  end,
}
-- Noivern 715
local noivern = {
  name = "noivern",
  pos = {x = 9, y = 4},
  config={extra = {retriggers1 = 2, retriggers2 = 1, chips1 = 20, chips2 = 40}},
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return{vars = {center.ability.extra.retriggers1, center.ability.extra.retriggers2, center.ability.extra.chips1, center.ability.extra.chips2}}
  end,
  rarity = "poke_safari",
  cost = 9,
  stage = "One",
  ptype = "Dragon",
  atlas = "poke_wow6",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and not context.end_of_round and context.cardarea == G.play then
      if context.other_card:get_id() == 2 then
        return{
          chips = card.ability.extra.chips1,
          card = card
        }
      elseif context.other_card:get_id() == 4 then
        return{
          chips = card.ability.extra.chips2,
          card = card
        }
      end
    end
    if context.repetition and not context.end_of_round and context.cardarea == G.play then
      if context.other_card:get_id() == 2 then
        return{
          message = localize('k_again_ex'),
          repetitions = card.ability.extra.retriggers1,
          card = card
        }
      elseif context.other_card:get_id() == 4 then
        return{
          message = localize('k_again_ex'),
          repetitions = card.ability.extra.retriggers2,
          card = card
        }
      end
    end
  end
}

list = {carvanha, sharpedo, mega_sharpedo, cottonee, whimsicott, noibat, noivern}

return {name = "WowzasWonder1", 
list = list
}
