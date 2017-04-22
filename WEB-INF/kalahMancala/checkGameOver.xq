(: THE XQUERY METHODS THAT IMPLEMENT THE GAME OVER CHECKING :)

xquery version "3.0" encoding "UTF-8";

module namespace cgo = "kalahMancala/checkGameOver";

import module namespace cm = "kalahMancala/common" at "common.xq";

declare variable $cgo:gameInstanceCollection := db:open("KalahMancala");

(: The game is over, when one of the players does not have any seeds in their houses anymore. :)
declare updating function cgo:checkGameOver($gameId as xs:string) {
  if (cgo:countSeedsOfHouses($gameId, 'player1', 'house1') = 0) then (
    let $gameInstance := $cgo:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]
    let $gameOver := $gameInstance/gameOver
    return (replace value of node $gameOver with 1,
            cgo:moveSeedsToStore($gameId, $gameInstance, "player2", "store2"))
  ) else if (cgo:countSeedsOfHouses($gameId, 'player2', 'house2') = 0) then (
    let $gameInstance := $cgo:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]
    let $gameOver := $gameInstance/gameOver
    return (replace value of node $gameOver with 1,
            cgo:moveSeedsToStore($gameId, $gameInstance, "player1", "store1"))
  ) else (
    (: The game is not over yet. :)
  )
};

(: Counts the number of seeds in a players houses. :)
declare %private function cgo:countSeedsOfHouses($gameId as xs:string, $player as xs:string, $house as xs:string) as xs:double {
    let $seeds := $cgo:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/*[name()=$player]/*[name()=$house]//numOfSeeds
    return fn:sum(data($seeds))
};

(: Move all the player seeds to their store. :)
declare %private updating function cgo:moveSeedsToStore($gameId as xs:string, $gameInstance as node(), $player as xs:string, $store as xs:string) {
  if (fn:starts-with($store, "store1")) then (
    let $pathToStore := $gameInstance/*[name()=$player]/*[name()=$store]/numOfSeeds
    let $updatedValue := data($pathToStore) + cgo:countSeedsOfHouses($gameId, "player1", "house1")
    return (replace value of node $pathToStore with $updatedValue,
            cgo:removeSeedsFromHouses($gameInstance, "player1", "house1"))
  ) else if (fn:starts-with($store, "store2")) then (
    let $pathToStore := $gameInstance/*[name()=$player]/*[name()=$store]/numOfSeeds
    let $updatedValue := data($pathToStore) + cgo:countSeedsOfHouses($gameId, "player2", "house2")
    return (replace value of node $pathToStore with $updatedValue,
            cgo:removeSeedsFromHouses($gameInstance, "player2", "house2"))
  ) else (
    (: Do nothing. :)
  )
};

(: Remove all seeds from a players houses. :)
declare %private updating function cgo:removeSeedsFromHouses($gameInstance as node(), $player as xs:string, $housepit as xs:string) {
  (cgo:removeSeedsFromSingleHouse($gameInstance, $player, $housepit, fn:concat($housepit, "1")),
   cgo:removeSeedsFromSingleHouse($gameInstance, $player, $housepit, fn:concat($housepit, "2")), 
   cgo:removeSeedsFromSingleHouse($gameInstance, $player, $housepit, fn:concat($housepit, "3")),
   cgo:removeSeedsFromSingleHouse($gameInstance, $player, $housepit, fn:concat($housepit, "4")), 
   cgo:removeSeedsFromSingleHouse($gameInstance, $player, $housepit, fn:concat($housepit, "5")),
   cgo:removeSeedsFromSingleHouse($gameInstance, $player, $housepit, fn:concat($housepit, "6")))
};

(: Empty a certain house. :)
declare %private updating function cgo:removeSeedsFromSingleHouse($gameInstance as node(), $player as xs:string, $housepit as xs:string, $house as xs:string) {
  let $pathToSeeds := $gameInstance/*[name()=$player]/*[name()=$housepit]/*[name()=$house]/numOfSeeds
  return (replace value of node $pathToSeeds with 0)
};
