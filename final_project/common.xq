(: THE COMMONLY USED XQUERY METHODS :)

xquery version "1.0" encoding "UTF-8";

module namespace cm = "kalahMancala/common";

(: Redirect to the XML to XHTML transformator. :)
declare function cm:redirectToTransformator($gameId as xs:string) {
    let $transformatorURL := fn:concat("http://localhost:8984/gxf/transform/", $gameId)
    return web:redirect($transformatorURL)
};

(: Redirect to check the special cases. :)
declare function cm:redirectToSpecialCases($gameId as xs:string, $startingPit as xs:string, $numOfStepsToMove as xs:decimal, $player as xs:decimal) {
  let $specialCasesURL := fn:concat("http://localhost:8984/gxf/specialCases/", $gameId, "/", $startingPit, "/", $numOfStepsToMove, "/", $player)
  return web:redirect($specialCasesURL)
};

(: Check, if game is over :)
declare function cm:checkGameOver($gameId as xs:string) {
  let $checkGameOverURL := fn:concat("http://localhost:8984/gxf/checkGameOver/", $gameId)
  return web:redirect($checkGameOverURL)
};

(: Generate a timestamp as an ID for the game instance. Remove white spaces. :)
declare function cm:generateGameId() as xs:string {
  let $dateTime := xs:string(fn:current-dateTime())
  return fn:translate($dateTime, '&#043;', '')
};

(: Returns the total difference in days between two dates :)
declare function cm:getAgeOfGame($gameInstance as node()) as xs:decimal {
  let $gameId := $gameInstance/@id
  let $gameDate := xs:date(fn:substring($gameId, 1, 10))
  let $duration := fn:days-from-duration(fn:current-date() - $gameDate)
  return fn:abs($duration)
};