---------------
-- Vars
---------------
local searchedName = nil;
jsonData = nil;

---------------
-- Private functions
---------------
local function addJsonDataClear()
  AuctionDataExtractor.Util.ActionQueue.AddJsonDataClear();
end

local function addSortByBuyoutAscending()
  AuctionDataExtractor.Util.ActionQueue.AddSortByBuyout();
end

local function addQueryAndExtracts()
  for index, itemName in pairs(AuctionDataExtractor.Constants.AuctionItemKeys) do
    AuctionDataExtractor.Core.Support.AddQueryAndExtract(itemName, false);
  end
end

local function addCleanup()
  AuctionDataExtractor.Util.ActionQueue.AddCleanup();
end

local function initUi()
  local buttonId = AuctionDataExtractor.Constants.ExecNextButtonLabel;
  AuctionDataExtractor.Util.Ui.AddButton(buttonId, AuctionDataExtractor.Core.Support.ExecNextQueueAction);
  AuctionDataExtractor.Util.Ui.BindKey(AuctionDataExtractor.Constants.ExecNextButtonKey, buttonId);
end

---------------
-- Exposed functions
---------------
local function init()
  initUi();
end

local function fillQ()
  addJsonDataClear();
  addSortByBuyoutAscending();
  addQueryAndExtracts();
  addCleanup();
end

local function getSearchedName()
  return searchedName;
end

local function setSearchedName(newSearchedName)
  searchedName = newSearchedName;
end

---------------
-- Interface
---------------
AuctionDataExtractor.Core.Main = {
  Init = init,
  FillQ = fillQ,
  GetSearchedName = getSearchedName,
  SetSearchedName = setSearchedName
};
