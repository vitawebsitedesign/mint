---------------
-- Vars
---------------
local auctionPage = nil;
local firstExecute = true;
local conflictingAddons = {"Auctioneer", "Auc-Advanced"};

---------------
-- Necessary prototypes
---------------
local addQueryAndExtract;
local cleanUp;

---------------
-- Private functions
---------------
local function recordItemBuyout(a)
  local valid = a ~= nil and a.name ~= nil and a.buyoutPrice ~= nil and a.count ~= nil;
	local name = AuctionDataExtractor.Core.Main.GetSearchedName();
  if (valid == false) then
    local msg = name .. " has no auctions on the 1st page - skipped item.";
		AuctionDataExtractor.Util.Ui.Chat(msg);
		return nil;
	end

	local copper = a.buyoutPrice / a.count;
  local gold = copper / 100 / 100;
	local i = AuctionDataExtractor.Util.Json.JsonForItem(name, gold);
	jsonData = AuctionDataExtractor.Util.Json.GetAppendedItemJson(jsonData, i);
end

local function setJsonData()
  jsonData = AuctionDataExtractor.Util.Json.Head();
end

local function sortByBuyoutAsc()
  AuctionDataExtractor.Core.WoWApiAdapter.ReverseSortByBuyout();
end

local function resetAuctionPageCounter()
  auctionPage = AuctionDataExtractor.Constants.FirstAuctionPage;
end

local function queryAuctionItem(itemName, itemClassIndex)
  if (not auctionPage) then
    resetAuctionPageCounter();
  end
  AuctionDataExtractor.Core.WoWApiAdapter.QueryAuctionItems(itemName, itemClassIndex, auctionPage);
  AuctionDataExtractor.Core.Main.SetSearchedName(itemName);
end

local function extractDataForItem(auction)
  recordItemBuyout(auction);
  resetAuctionPageCounter();
end

local function extractDataForNextPage(searchedName)
  auctionPage = auctionPage + 1;
  addQueryAndExtract(searchedName, true);
end

local function extractDataForVariant()
  local searchedName = AuctionDataExtractor.Core.Main.GetSearchedName();
  local cheapestVariant = AuctionDataExtractor.Core.WoWApiAdapter.CheapestVariant(searchedName);
  local variantFound = cheapestVariant ~= nil;
  if (variantFound == true) then
    extractDataForItem(cheapestVariant);
    AuctionDataExtractor.Util.Ui.Chat("variant found");  -- dm
  else
    AuctionDataExtractor.Util.Ui.Chat("variant NOT found");  -- dm
  end
  resetAuctionPageCounter();
end

local function tryExtractData()
  local searchedName = AuctionDataExtractor.Core.Main.GetSearchedName();
  local a = AuctionDataExtractor.Core.WoWApiAdapter.CheapestBuyoutAuction(searchedName);
  local itemFound = tonumber(a) == nil;

  if (itemFound == true) then
    extractDataForItem(a);
  else
    if (a == AuctionDataExtractor.Constants.AuctionNotFoundCodes.MORE_PAGES) then
      AuctionDataExtractor.Util.Ui.Chat(searchedName .. " not on current page. Will extract data on next page");  -- dm
      extractDataForNextPage(searchedName);
    elseif (a == AuctionDataExtractor.Constants.AuctionNotFoundCodes.NO_MORE_PAGES) then
      AuctionDataExtractor.Util.Ui.Chat("Tried to check all pages for " .. searchedName .. " - found none, using variant instead");  -- dm
      extractDataForVariant();
    end
  end
end

local function handleAction(t, itemName, itemClassIndex)
  if (t == AuctionDataExtractor.Constants.ActionTypeClear) then
    setJsonData();
  elseif (t == AuctionDataExtractor.Constants.ActionTypeSort) then
    sortByBuyoutAsc();
  elseif (t == AuctionDataExtractor.Constants.ActionTypeQuery) then
    queryAuctionItem(itemName, itemClassIndex);
  elseif (t == AuctionDataExtractor.Constants.ActionTypeExtract) then
    tryExtractData();
  elseif (t == AuctionDataExtractor.Constants.ActionTypeCleanup) then
    cleanUp();
  else
    return false;
  end

  return true;
end

local function enableConflictingAddons()
  for a = 1, #conflictingAddons do
    local addon = conflictingAddons[a];
    EnableAddOn(addon);
  end
end

---------------
-- Exposed functions
---------------
local function execNextQueueAction()
  if (firstExecute == true) then
    firstExecute = false;
    AuctionDataExtractor.Core.Main.FillQ();
  end

  local action = AuctionDataExtractor.Util.ActionQueue.Next();
  if action == nil then
    return false;
  end

  local t = action.type;
  local itemName = action.itemName;
  local itemClassIndex = action.itemClassIndex;
  local handledAction = handleAction(t, itemName, itemClassIndex);
  if (handledAction == true) then
    return true;
  end

  local msg = "No code to handle action type";
  if (t ~= nil) then
    msg = msg .. " " .. t;
  end

  message(msg);
  return false;
end

function addQueryAndExtract(itemName, front)
  if (front == true) then
    AuctionDataExtractor.Util.ActionQueue.AddBuyoutExtract(front);
    AuctionDataExtractor.Util.ActionQueue.AddQuery(itemName, front);
  else
    AuctionDataExtractor.Util.ActionQueue.AddQuery(itemName, front);
    AuctionDataExtractor.Util.ActionQueue.AddBuyoutExtract(front);
  end
end

function cleanUp()
  jsonData = AuctionDataExtractor.Util.Json.GetAppendedJsonTail(jsonData);
  enableConflictingAddons();
  Logout();
end

local function getAuctionPage()
  return auctionPage;
end

---------------
-- Interface
---------------
AuctionDataExtractor.Core.Support = {
  ExecNextQueueAction = execNextQueueAction,
  AddQueryAndExtract = addQueryAndExtract,
  CleanUp = cleanUp,
  GetAuctionPage = getAuctionPage
};
