---------------
-- Vars
---------------
local queue = {};

---------------
-- Private functions
---------------
local function getSearchName(auctionItemKeysIndex)
  return AuctionDataExtractor.Constants.AuctionItemKeys[auctionItemKeysIndex];
end

local function getSearchedName(auctionItemKeysIndex)
  local i = auctionItemKeysIndex;
	if (i > 1) then
		return AuctionDataExtractor.Constants.AuctionItemKeys[i - 1];
	end
	return "no item searched";
end

local function addActionToQueue(action, front)
  if (front == true) then
    table.insert(queue, 1, action);
  else
    table.insert(queue, action);
  end
end

local function peekFront()
  return queue[1];
end

---------------
-- Exposed functions
---------------
local function addJsonDataClear()
  addActionToQueue({
    ["type"] = AuctionDataExtractor.Constants.ActionTypeClear
  }, false);
end

local function addSortByBuyout()
  addActionToQueue({
    ["type"] = AuctionDataExtractor.Constants.ActionTypeSort
  }, false);
end

local function addQuery(itemName, front)
	local itemClassKey = AuctionDataExtractor.Constants.AuctionItemValues[itemName];
	local itemClassIndex = AuctionDataExtractor.Constants.ItemClasses[itemClassKey];
  addActionToQueue({
    ["type"] = AuctionDataExtractor.Constants.ActionTypeQuery,
    ["itemName"] = itemName,
    ["itemClassIndex"] = itemClassIndex;
  }, front);
end

local function addBuyoutExtract(front)
  addActionToQueue({
    ["type"] = AuctionDataExtractor.Constants.ActionTypeExtract
  }, front);
end

local function addCleanup()
  addActionToQueue({
    ["type"] = AuctionDataExtractor.Constants.ActionTypeCleanup
  }, false);
end

local function next()
  return table.remove(queue, 1);
end

local function finishedExtractingData()
  local a = peekFront();
  return a.type == AuctionDataExtractor.Constants.ActionTypeCleanup;
end

---------------
-- Interface
---------------
AuctionDataExtractor.Util.ActionQueue = {
  AddJsonDataClear = addJsonDataClear,
  AddSortByBuyout = addSortByBuyout,
  AddQuery = addQuery,
  AddBuyoutExtract = addBuyoutExtract,
  AddCleanup = addCleanup,
  Next = next,
  FinishedExtractingData = finishedExtractingData
};
