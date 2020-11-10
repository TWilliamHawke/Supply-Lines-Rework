local function calculate_supply_penalty(supply_balance, num_of_armies)
  return math.ceil(supply_balance/(num_of_armies^0.35))
end