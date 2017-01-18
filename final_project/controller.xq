(: THE CONTROLLER METHODS FOR THE KALAH MANCALA GAME :)

xquery version "1.0" encoding "UTF-8";

module namespace c = "kalahMancala/controller";

import module namespace cm = "kalahMancala/common" at "common.xq";
import module namespace ms = "kalahMancala/moveSeeds" at "moveSeeds.xquery";
import module namespace go = "kalahMancala/checkGameOver" at "checkGameOver.xquery"; 
declare namespace xslt = "http://basex.org/modules/xslt";

declare variable $c:mancalaStartScreen := doc("startScreen.html");
declare variable $c:gameInstanceCollection := db:open("KalahMancala");
declare variable $c:transformator := doc("MancalaTransformator.xsl");

(: Display the start screen to the player. :)
declare %rest:path("/gxf/kalahMancala") %rest:GET function c:start() {
  $c:mancalaStartScreen
};

(: Transform the game session from the database to HTML using XSLT. :)
declare %rest:path('/gxf/transform/{$gameId}') %rest:GET %output:media-type("text/html") function c:transformToHtml($gameId as xs:string) {
  let $gameInstance := $c:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]
  return xslt:transform-text($gameInstance, $c:transformator)
};

(: Clear the database. Finished games and games with a timestamp older than 2 days are removed. :)
declare %rest:path("/gxf/refreshDatabase") %rest:GET updating function c:refreshDatabase() {
  for $game in $c:gameInstanceCollection/gameInstanceCollection/mancalaGame
  where ($game/gameOver/text() = 1 or cm:getAgeOfGame($game) >= 2)
  return delete nodes $game
};

(: Create a new game instance in the database. :)
declare %rest:path("/gxf/newGame") %rest:GET updating function c:newGame() {
  let $collection := $c:gameInstanceCollection/gameInstanceCollection
  let $gameId := cm:generateGameId()
  let $newGame := (
    <mancalaGame id = "{$gameId}">
      <gameOver>0</gameOver>
      <turnOfPlayerOne>{if((fn:seconds-from-time(xs:time(fn:current-time()))*1000)mod 2 = 0) then 0 else 1}</turnOfPlayerOne>
      <player1>
        <store1>
          <numOfSeeds>0</numOfSeeds>
        </store1>
        <house1>
          <house11>
            <numOfSeeds>4</numOfSeeds>
          </house11>
          <house12>
            <numOfSeeds>4</numOfSeeds>
          </house12>
          <house13>
            <numOfSeeds>4</numOfSeeds>
          </house13>
          <house14>
            <numOfSeeds>4</numOfSeeds>
          </house14>
          <house15>
            <numOfSeeds>4</numOfSeeds>
          </house15>
          <house16>
            <numOfSeeds>4</numOfSeeds>
          </house16>
        </house1>
      </player1>
      <player2>
        <store2>
          <numOfSeeds>0</numOfSeeds>
        </store2>
        <house2>
          <house21>
            <numOfSeeds>4</numOfSeeds>
          </house21>
          <house22>
            <numOfSeeds>4</numOfSeeds>
          </house22>
          <house23>
            <numOfSeeds>4</numOfSeeds>
          </house23>
          <house24>
            <numOfSeeds>4</numOfSeeds>
          </house24>
          <house25>
            <numOfSeeds>4</numOfSeeds>
          </house25>
          <house26>
            <numOfSeeds>4</numOfSeeds>
          </house26>
        </house2>
      </player2>
    </mancalaGame>
  )
  return (insert nodes $newGame as first into $collection, db:output(cm:redirectToTransformator($gameId)))
};

(: React to the move of a player and distribute the required seeds. :)
declare updating %rest:path('/gxf/move/{$gameId}/{$house}') %rest:GET function c:moveSeeds($gameId as xs:string, $house as xs:string) {
  ms:moveSeeds($gameId, $house)
};

(: Check the special cases after distributing the seeds. :)
declare updating %rest:path('/gxf/specialCases/{$gameId}/{$startingPit}/{$numOfStepsToMove}/{$player}') %rest:GET function c:checkSpecialCases($gameId as xs:string, $startingPit as xs:string, $numOfStepsToMove as xs:decimal, $player as xs:decimal) {
  (: TODO - call the checkSpecialCases method. :)
};

(: Check if the game is over after distributing the seeds. :) 
declare updating %rest:path('/gxf/checkGameOver/{$gameId}') %rest:GET function c:checkGameOver($gameId as xs:string) {
  go:checkGameOver($gameId), db:output(cm:redirectToTransformator($gameId))
}; 
