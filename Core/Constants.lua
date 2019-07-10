---------------
-- Variables
---------------
local execNextButtonLabel = "exec next";
local execNextButtonKey = "F9";
local actionTypeClear = "CLEAR";
local actionTypeSort = "SORT";
local actionTypeQuery = "QUERY";
local actionTypeExtract = "EXTRACT";
local actionTypeCleanup = "CLEANUP";
local firstAuctionPage = 0;
local auctionsPerPage = 50;
local auctionNotFoundCodes = {
  MORE_PAGES = 0,
  NO_MORE_PAGES = 1
};

local itemClasses = {
  ["weapon"] = 1,
  ["armor"] = 2,
  ["container"] = 3,
  ["consumable"] = 4,
  ["trade goods"] = 5,
  ["projectile"] = 6,
  ["quiver"] = 7,
  ["recipe"] = 8,
  ["gem"] = 9,
  ["miscellaneous"] = 10,
  ["quest"] = 11
};

local auctionItemKeys = {"primal earth","primal water","primal air","primal fire","primal mana","netherweave cloth","arcane dust","primal life","primal shadow","fel iron ore","eternium ore","adamantite bar","khorium ore","thorium bar","arcane crystal","silver ore","copper ore","tin ore","moss agate","lesser moonstone","small lustrous pearl","soul dust","stranglekelp","kingsblood","gold ore","jade","citrine","truesilver ore","star ruby","aquamarine","flask of mojo","rugged leather","green dragonscale","perfect deviate scale","deviate scale","medium leather","cured medium hide","elixir of defense","spider's silk","heavy leather","cured heavy hide","raptor hide","large fang","fel lotus","mana thistle","ancient lichen","dreaming glory","terocone","netherbloom","nightmare vine","mote of earth","swiftthistle","briarthorn","blood garnet","flame spessarite","azure moonstone","skyfire diamond","deep peridot","shadow draenite","golden draenite","earthstorm diamond","living ruby","dawnstone","star of elune","nightseye","talasite","noble topaz","primal might","primal mooncloth","shadowcloth","spellcloth","felsteel bar","hardened adamantite bar","khorium bar","arcanite bar","heavy silver ring","moonsoul crown","golden ring of power","truesilver commander's ring","aquamarine signet","green dragonscale leggings","deviate scale belt","toughened leather gloves","flask of fortification","flask of mighty restoration","haste potion","heroic potion","destruction potion","ironshield potion","swiftness potion","destructive skyfire diamond","thundering skyfire diamond","chaotic skyfire diamond","enigmatic skyfire diamond","mystical skyfire diamond","swift skyfire diamond","brutal earthstorm diamond","relentless earthstorm diamond","tenacious earthstorm diamond","bracing earthstorm diamond","insightful earthstorm diamond","powerful earthstorm diamond","bright living ruby","subtle living ruby","delicate living ruby","teardrop living ruby","runed living ruby","bold living ruby","flashing living ruby","brilliant dawnstone","gleaming dawnstone","thick dawnstone","smooth dawnstone","mystic dawnstone","great dawnstone","rigid dawnstone","sparkling star of elune","solid star of elune","lustrous star of elune","stormy star of elune","royal nightseye","glowing nightseye","shifting nightseye","infused nightseye","balanced nightseye","dazzling talasite","jagged talasite","steady talasite","enduring talasite","radiant talasite","luminous noble topaz","potent noble topaz","inscribed noble topaz","glinting noble topaz","wicked noble topaz","veiled noble topaz","copper ore","tin ore","iron ore","mithril ore","thorium ore","fel iron ore","adamantite ore","malachite","tigerseye","shadowgem","lesser moonstone","moss agate","shadowgem","aquamarine","citrine","jade","citrine","jade","lesser moonstone","aquamarine","star ruby","star ruby","aquamarine","citrine","blue sapphire","large opal","azerothian diamond","huge emerald","azerothian diamond","blue sapphire","huge emerald","large opal","star ruby","azure moonstone","blood garnet","deep peridot","flame spessarite","golden draenite","shadow draenite","noble topaz","dawnstone","living ruby","nightseye","star of elune","talasite","adamantite powder","azure moonstone","blood garnet","deep peridot","flame spessarite","golden draenite","shadow draenite","dawnstone","living ruby","nightseye","noble topaz","star of elune","talasite"};

local auctionItemValues = {["primal life"]="trade goods",["primal earth"]="trade goods",["primal water"]="trade goods",["primal air"]="trade goods",["primal fire"]="trade goods",["primal mana"]="trade goods",["primal shadow"]="trade goods",["fel iron ore"]="trade goods",["eternium ore"]="trade goods",["adamantite bar"]="trade goods",["silver ore"]="trade goods",["copper ore"]="trade goods",["tin ore"]="trade goods",["moss agate"]="gem",["lesser moonstone"]="gem",["small lustrous pearl"]="gem",["soul dust"]="trade goods",["stranglekelp"]="trade goods",["kingsblood"]="trade goods",["gold ore"]="trade goods",["jade"]="gem",["citrine"]="gem",["truesilver ore"]="trade goods",["star ruby"]="gem",["aquamarine"]="gem",["flask of mojo"]="trade goods",["black pearl"]="gem",["thorium ore"]="trade goods",["khadgar's whisker"]="trade goods",["goldthorn"]="trade goods",["fel lotus"]="trade goods",["mana thistle"]="trade goods",["ancient lichen"]="trade goods",["terocone"]="trade goods",["netherbloom"]="trade goods",["nightmare vine"]="trade goods",["mote of earth"]="trade goods",["swiftthistle"]="trade goods",["briarthorn"]="trade goods",["blood garnet"]="gem",["flame spessarite"]="gem",["azure moonstone"]="gem",["skyfire diamond"]="gem",["deep peridot"]="gem",["shadow draenite"]="gem",["golden draenite"]="gem",["earthstorm diamond"]="gem",["living ruby"]="gem",["dawnstone"]="gem",["star of elune"]="gem",["nightseye"]="gem",["talasite"]="gem",["noble topaz"]="gem",["primal might"]="trade goods",["felsteel bar"]="trade goods",["hardened adamantite bar"]="trade goods",["khorium bar"]="trade goods",["khorium ore"]="trade goods",["heavy silver ring"]="armor",["moonsoul crown"]="armor",["golden ring of power"]="armor",["truesilver commander's ring"]="armor",["aquamarine signet"]="armor",["flask of fortification"]="consumable",["flask of mighty restoration"]="consumable",["haste potion"]="consumable",["heroic potion"]="consumable",["destruction potion"]="consumable",["ironshield potion"]="consumable",["swiftness potion"]="consumable",["destructive skyfire diamond"]="gem",["thundering skyfire diamond"]="gem",["chaotic skyfire diamond"]="gem",["enigmatic skyfire diamond"]="gem",["mystical skyfire diamond"]="gem",["swift skyfire diamond"]="gem",["brutal earthstorm diamond"]="gem",["relentless earthstorm diamond"]="gem",["tenacious earthstorm diamond"]="gem",["bracing earthstorm diamond"]="gem",["insightful earthstorm diamond"]="gem",["powerful earthstorm diamond"]="gem",["bright living ruby"]="gem",["subtle living ruby"]="gem",["delicate living ruby"]="gem",["teardrop living ruby"]="gem",["runed living ruby"]="gem",["bold living ruby"]="gem",["flashing living ruby"]="gem",["brilliant dawnstone"]="gem",["gleaming dawnstone"]="gem",["thick dawnstone"]="gem",["smooth dawnstone"]="gem",["mystic dawnstone"]="gem",["great dawnstone"]="gem",["quick dawnstone"]="gem",["rigid dawnstone"]="gem",["sparkling star of elune"]="gem",["solid star of elune"]="gem",["lustrous star of elune"]="gem",["rigid star of elune"]="gem",["stormy star of elune"]="gem",["royal nightseye"]="gem",["glowing nightseye"]="gem",["soverign nightseye"]="gem",["shifting nightseye"]="gem",["infused nightseye"]="gem",["balanced nightseye"]="gem",["dazzling talasite"]="gem",["jagged talasite"]="gem",["steady talasite"]="gem",["enduring talasite"]="gem",["forceful talasite"]="gem",["radiant talasite"]="gem",["luminous noble topaz"]="gem",["potent noble topaz"]="gem",["inscribed noble topaz"]="gem",["glinting noble topaz"]="gem",["wicked noble topaz"]="gem",["veiled noble topaz"]="gem",["iron ore"]="trade goods",["mithril ore"]="trade goods",["adamantite ore"]="trade goods",["malachite"]="gem",["tigerseye"]="gem",["shadowgem"]="gem",["blue sapphire"]="gem",["large opal"]="gem",["azerothian diamond"]="gem",["huge emerald"]="gem",["adamantite powder"]="trade goods",["green dragonscale leggings"]="armor",["rugged leather"]="trade goods",["green dragonscale"]="trade goods",["deviate scale belt"]="armor",["perfect deviate scale"]="trade goods",["deviate scale"]="trade goods",["toughened leather gloves"]="armor",["medium leather"]="trade goods",["cured medium hide"]="trade goods",["elixir of defense"]="consumable",["spider's silk"]="trade goods",["barbaric bracers"]="armor",["heavy leather"]="trade goods",["cured heavy hide"]="trade goods",["raptor hide"]="trade goods",["large fang"]="trade goods",["arcanite bar"]="trade goods",["thorium bar"]="trade goods",["arcane crystal"]="gem",["dreaming glory"]="trade goods",["primal mooncloth"]="trade goods",["shadowcloth"]="trade goods",["spellcloth"]="trade goods",["netherweave cloth"]="trade goods",["arcane dust"]="trade goods"};

---------------
-- Namespaces
---------------
AuctionDataExtractor = {};
AuctionDataExtractor.Core = {};
AuctionDataExtractor.Util = {};

---------------
-- Interface
---------------
AuctionDataExtractor.Constants = {
  ExecNextButtonLabel = execNextButtonLabel,
  ExecNextButtonKey = execNextButtonKey,
  LastPageToExtract = lastPageToExtract,
  ActionTypeClear = actionTypeClear,
  ActionTypeSort = actionTypeSort,
  ActionTypeQuery = actionTypeQuery,
  ActionTypeExtract = actionTypeExtract,
  ActionTypeCleanup = actionTypeCleanup,
  FirstAuctionPage = firstAuctionPage,
  AuctionsPerPage = auctionsPerPage,
  AuctionNotFoundCodes = auctionNotFoundCodes,
  ItemClasses = itemClasses,
  AuctionItemKeys = auctionItemKeys,
  AuctionItemValues = auctionItemValues
};
