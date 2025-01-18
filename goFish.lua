math.randomseed(os.time())

local input = function(Prompt)
	io.write(Prompt)
	return tostring(io.read())
end

local Hands = {
	CPU = {};
	Player = {};
}

for i = 1, 10 do
	Hands.CPU[i] = 0
	Hands.Player[i] = 0
end

for i = 1, 5 do
	for Player, Hand in next, Hands do
		local n = math.random(1, 10)
		Hand[n] = Hand[n] + 1
	end
end

local CheckForPairs = function()
	for Player, Hand in next, Hands do
		for i,v in next, Hand do
			if (v > 1) then
				print(Player .. " made a pair of " .. tostring(i) .. "'s!")
				Hand[i] = Hand[i] - 2
			end
		end
	end
end

local Play = function(Player, OtherPlayer, Request)
	print(Player .. ": " .. OtherPlayer .. ", do you have a " .. tostring(Request) .. "?")
	if (Hands[OtherPlayer][Request] > 0) then
		Hands[OtherPlayer][Request] = Hands[OtherPlayer][Request] - 1
		Hands[Player][Request] = Hands[Player][Request] + 1
		print(OtherPlayer .. ": Yes I do!")
	else
		local Card = math.random(1, 10)
		Hands[Player][Card] = Hands[Player][Card] + 1
		print(OtherPlayer .. ": Go Fish!")
	end
end

local GetListOfCards = function(Hand)
	local Cards = {}
	for i,v in next, Hand do
		for _ = 1, v do
			table.insert(Cards, i)
		end
	end
	return Cards
end

local CPUMakeDecision = function(Hand)
	local Cards = GetListOfCards(Hand)
	return Cards[math.random(1, #Cards)]
end

CheckForPairs()

local Trick = -1

local Players = {}
for i,v in next, Hands do
	table.insert(Players, i)
end

local WhosTurn = function()
	Trick = Trick + 1
	return Players[(Trick % #Players) + 1]
end

local GameOver = false
local Turn
repeat
	Turn = WhosTurn()
	print("It's " .. Turn .. "'s turn!")
	
	if (Turn == "Player") then
		print("Your Hand:")
		print(table.concat(GetListOfCards(Hands.Player), " "))
		local Request = math.floor(tonumber(input("What card would you like to request?: ")))
		Play(Turn, "CPU", Request)
	else
		Play("CPU", "Player", CPUMakeDecision(Hands.CPU))
	end
	
	CheckForPairs()
	
	for i,v in next, Hands do
		if (#GetListOfCards(v) == 0) then
			GameOver = true
			break
		end
	end
until (GameOver)

print("Game Over! " .. Turn .. " won!")