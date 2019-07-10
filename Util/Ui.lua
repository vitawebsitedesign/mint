---------------
-- Exposed functions
---------------
local function addButton(label, clickHandler)
	local y = 0;
	local b = CreateFrame("Button", label, UIParent, "OptionsButtonTemplate");
	b:SetPoint("BOTTOMLEFT", 0, y);
	b:SetText(label);
	b:SetScript("OnClick", clickHandler);
	b:Show();
end

local function bindKey(key, button)
  local accountBindings = 1;
	local toCharProfileOnly = 2;
	LoadBindings(accountBindings);
	SetBindingClick(key, button);
	SaveBindings(toCharProfileOnly);
end

local function chat(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg);
end

---------------
-- Interface
---------------
AuctionDataExtractor.Util.Ui = {
  AddButton = addButton,
	BindKey = bindKey,
	Chat = chat
};
