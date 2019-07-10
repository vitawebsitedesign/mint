---------------
-- Exposed functions
---------------
local function head()
	return "{";
end

local function jsonForItem(name, gold)
	return '"' .. name .. '":' .. gold;
end

local function tail()
	return "}";
end

local function getAppendedItemJson(current, append)
  local j = current .. append;
  local finished = AuctionDataExtractor.Util.ActionQueue.FinishedExtractingData();
	if (finished == false) then
		j = j .. ",";
	end
	return j;
end

local function getAppendedJsonTail(json)
	local t = tail();
	return json .. t;
end

---------------
-- Interface
---------------
AuctionDataExtractor.Util.Json = {
  Head = head,
  JsonForItem = jsonForItem,
  Tail = tail,
  GetAppendedItemJson = getAppendedItemJson,
  GetAppendedJsonTail = getAppendedJsonTail
};
