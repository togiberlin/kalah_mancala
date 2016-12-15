(: THE COMMONLY USED XQUERY METHODS :)

xquery version "1.0";

module namespace cm = "kalahMancala/common";

declare namespace xslt = 'http://basex.org/modules/xslt';

declare variable $cm:gameInstanceCollection := db:open("KalahMancala");
declare variable $cm:transformator := doc("MancalaTransformator.xsl");

(: Transform the game session from the database to HTML using XSLT :)
declare %rest:path('/transform/{$gameId}') %rest:GET %output:media-type("text/html") function cm:transformToHtml($gameId as xs:string) {
  let $gameInstance := $cm:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]
  return xslt:transform-text($gameInstance, $cm:transformator)
};