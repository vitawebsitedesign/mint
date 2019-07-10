---------------
-- Private functions
---------------
local function getAuctionByIndex(listType, index)
	local auction;
	local lastIndexOnPage, totalAuctions = GetNumAuctionItems(listType);
	if (index >= 0 and index <= lastIndexOnPage) then
		auction = {
		};

		-- Get the auction information.
		local name, texture, count, quality, canUse, level, minBid, minIncrement, buyoutPrice, bidAmount, highBidder, owner = GetAuctionItemInfo(listType, index);
		auction.name = name;
		auction.count = count;
		auction.minBid = minBid;
		auction.minIncrement = minIncrement;
		auction.buyoutPrice = buyoutPrice;
		auction.bidAmount = bidAmount;
		auction.highBidder = (highBidder ~= nil);
		auction.owner = owner;

		-- Get the time left.
		local timeLeft = GetAuctionItemTimeLeft(listType, index);
		auction.timeLeft = timeLeft or 0;
	end
	return auction;
end

local function firstMatchingAuctionOnPage(searchedName, batch)
	local searchedNameLower = searchedName:lower();

	for listIndex = 1, batch, 1 do
		local a = getAuctionByIndex("list", listIndex);
		local auctionNameLower = a.name:lower();
		local exactMatch = auctionNameLower == searchedNameLower;
		local hasBuyoutPrice = a.buyoutPrice > 0;
		if (exactMatch and hasBuyoutPrice) then
			return a;
		end
	end

	return nil;
end

local function morePages(count)
	local page = AuctionDataExtractor.Core.Support.GetAuctionPage();
	local viewingUpTo = (page + 1) * AuctionDataExtractor.Constants.AuctionsPerPage;
	return viewingUpTo < count;
end

local function auctionNotFoundCode(count)
	if (morePages(count)) then
		return AuctionDataExtractor.Constants.AuctionNotFoundCodes.MORE_PAGES
	end
	return AuctionDataExtractor.Constants.AuctionNotFoundCodes.NO_MORE_PAGES;
end

---------------
-- Exposed functions
---------------
local function reverseSortByBuyout()
  SortAuctionItems("list", "buyout");
end

local function queryAuctionItems(name, itemClassIndex, page)
  QueryAuctionItems(name, nil, nil, 0, itemClassIndex, 0, page);
end

local function cheapestVariant(searchedName)
	local itemClass = AuctionDataExtractor.Constants.AuctionItemValues[searchedName];
	if (itemClass == nil) then
		message("Failed to get item class for " .. searchedName);
	elseif (itemClass:lower() == "armor") then
    -- Armor items can have variants. In this case, we can accept the value of a variant instead
    local msg = searchedName .. " not found. Using price of 1st variant result instead.";
		AuctionDataExtractor.Util.Ui.Chat(msg);
		return getAuctionByIndex("list", 1);
	end
	return nil;
end

local function cheapestBuyoutAuction(searchedName)
	local batch, count = GetNumAuctionItems("list");
	local a = firstMatchingAuctionOnPage(searchedName, batch);
	local auctionFound = a ~= nil;

	if (auctionFound == true) then
		return a;
	end
	return auctionNotFoundCode(count);
end

---------------
-- Interface
---------------
AuctionDataExtractor.Core.WoWApiAdapter = {
  ReverseSortByBuyout = reverseSortByBuyout,
	QueryAuctionItems = queryAuctionItems,
	CheapestVariant = cheapestVariant,
  CheapestBuyoutAuction = cheapestBuyoutAuction
};
