(: THE XQUERY METHODS THAT IMPLEMENT THE SPECIAL CASE CHECKING :)

xquery version "3.0" encoding "UTF-8";

module namespace csc = "kalahMancala/checkSpecialCases";

import module namespace cm = "kalahMancala/common" at "common.xq";

declare variable $csc:gameInstanceCollection := db:open("KalahMancala");

(: Check the two possible special cases. :)
declare updating function csc:checkSpecialCases($gameId as xs:string, $startingPit as xs:string, $numOfStepsToMove as xs:decimal, $currentPlayer as xs:decimal) {
  let $lastPit := csc:getLastPit($startingPit, $numOfStepsToMove, $currentPlayer)
  let $currentStore := csc:getCurrentPlayersStore($currentPlayer)
  return (csc:specialCase1($gameId, $lastPit, $currentPlayer, $currentStore),
          csc:specialCase2($gameId, $lastPit, $currentPlayer, $currentStore, $numOfStepsToMove), db:output(cm:redirectToCheckGameOver($gameId)))
};

(: If the last pit is a house, which had no seeds before the distribution and the opposite house contains seeds after the distribution,
   then move the seeds from the last pit and from the opposite pit to the players store. :)
declare %private updating function csc:specialCase1($gameId as xs:string, $lastPit as xs:string, $currentPlayer as xs:decimal, $currentStore as xs:string) {
  if (csc:getIsHouseOfCurrentPlayer($lastPit, $currentPlayer) and
      csc:getLastPitWasEmpty($gameId, $lastPit) and
      csc:getOppositePitHasSeeds($gameId, $lastPit)) then (
    let $oppositePit := csc:getOppositePit($lastPit)
    return csc:fillPlayersStore($gameId, $currentStore, $lastPit, $oppositePit)
  ) else (
    (: Return, no special case to handle. :)
  )
};

(: If the last pit is the players store, then the player receives a second turn. :)
declare %private updating function csc:specialCase2($gameId as xs:string, $lastPit as xs:string, $currentPlayer as xs:decimal, $currentStore as xs:string, $numOfStepsToMove as xs:decimal) {
  if (fn:starts-with($lastPit, $currentStore) or $numOfStepsToMove = 0) then (
    (: Special case or no seeds distributed. The current player receives a second turn. :)
  ) else (
    (: No Special Case. Other players turn. :)
    if ($currentPlayer = 1) then (
      replace value of node $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/turnOfPlayerOne with "0"
    ) else (
      replace value of node $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/turnOfPlayerOne with "1"
    )
  )
};

(: ---- Getter functions ---- :)

(: Get the store of the current player. :)
declare %private function csc:getCurrentPlayersStore($currentPlayer as xs:decimal) as xs:string {
  if ($currentPlayer = 1) then (
    "store1"
  ) else (
    "store2"
  )
};

(: Check if the last pit is a house from the current player. :)
declare %private function csc:getIsHouseOfCurrentPlayer($lastPit as xs:string, $currentPlayer as xs:decimal) as xs:boolean {
  if ($currentPlayer = 1) then
    if (fn:starts-with($lastPit, "house1")) then (
      true()
    ) else (
      false()
    )
  else if ($currentPlayer = 2) then (
    if (fn:starts-with($lastPit, "house2")) then (
      true()
    )
    else (
      false()
    )
  ) else (
    false()
  )
};

(: Check if the last pit was empty before. :)
declare %private function csc:getLastPitWasEmpty($gameId as xs:string, $lastPit as xs:string) as xs:boolean {
  if (xs:decimal($csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]//*[name()=$lastPit]/numOfSeeds/text()) = 1) then (
    true()
  ) else (
    false()
  )
};

(: Check if the opposite pit contains any seeds. :)
declare %private function csc:getOppositePitHasSeeds($gameId as xs:string, $lastPit as xs:string) as xs:boolean {
  if (fn:starts-with($lastPit, "store")) then (
    false()
  ) else if (xs:decimal($csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]//*[name()=csc:getOppositePit($lastPit)]/numOfSeeds/text()) > 0) then (
    true()
  ) else (
    false()
  )
};

(: Get the opposite house. :)
declare %private function csc:getOppositePit($lastPit as xs:string) as xs:string {
  if (fn:starts-with($lastPit, "house1")) then (
    let $lastPitNumber := (xs:decimal(fn:substring-after($lastPit, "house"))) + 10
    return fn:concat("house", $lastPitNumber)
  ) else (
    let $lastPitNumber := (xs:decimal(fn:substring-after($lastPit, "house"))) - 10
    return fn:concat("house", $lastPitNumber)
  )
};

(: Returns the last pit (numOfStepsToMove = numOfSeeds mod 13). :)
declare %private function csc:getLastPit($startingPit as xs:string, $numOfStepsToMove as xs:decimal, $player as xs:decimal) {
  if ($numOfStepsToMove mod 13 = 0) then (
    $startingPit
  ) else if (fn:starts-with($startingPit, 'store1')) then (
    let $nextPit := "house21"
    return csc:getLastPit($nextPit, $numOfStepsToMove - 1, $player)
  ) else if (fn:starts-with($startingPit, 'store2')) then (
    let $nextPit := "house16"
    return csc:getLastPit($nextPit, $numOfStepsToMove - 1, $player)
  ) else if (fn:starts-with($startingPit, 'house11')) then (
    if ($player = 1) then (
      let $nextPit := "store1"
      return csc:getLastPit($nextPit, $numOfStepsToMove - 1, $player)
    ) else (
      let $nextPit := "house21"
      return csc:getLastPit($nextPit, $numOfStepsToMove - 1, $player)
    )
  ) else if (fn:starts-with($startingPit, 'house26')) then (
    if ($player = 2) then (
      let $nextPit := "store2"
      return csc:getLastPit($nextPit, $numOfStepsToMove - 1, $player)
    ) else (
      let $nextPit := "house16"
      return csc:getLastPit($nextPit, $numOfStepsToMove - 1, $player)
    )
  ) else if (fn:starts-with(cm:getNumberFromTag($startingPit), '1')) then (
    let $nextPitNum := xs:decimal(cm:getNumberFromTag($startingPit)) - 1
    let $nextPit := fn:concat('house', $nextPitNum)
    return csc:getLastPit($nextPit, $numOfStepsToMove - 1, $player)
  ) else (
    let $nextPitNum := xs:decimal(cm:getNumberFromTag($startingPit)) + 1
    let $nextPit := fn:concat('house', $nextPitNum)
    return csc:getLastPit($nextPit, $numOfStepsToMove - 1, $player)
  )
};

(: ---- Setter functions ---- :)

(: Take the seeds from the last pit and the opposite pit and move them to the players store. :)
declare %private updating function csc:fillPlayersStore($gameId as xs:string, $currentStore as xs:string, $lastPit as xs:string, $oppositePit as xs:string) {
  let $pathToStoreSeeds := $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]//*[name()=$currentStore]/numOfSeeds/text()
  let $newStoreValue := (xs:decimal($pathToStoreSeeds) +
                         xs:decimal($csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]//*[name()=$lastPit]/numOfSeeds/text()) + 
                         xs:decimal($csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]//*[name()=$oppositePit]/numOfSeeds/text()))
  return (replace value of node $pathToStoreSeeds with $newStoreValue, csc:setPitsToZero($gameId, $lastPit, $oppositePit))
};

(: After the players store is successfully filled, set the seed count in the last pit and the opposite pit to zero. :)
declare %private updating function csc:setPitsToZero($gameId as xs:string, $lastPit as xs:string, $oppositePit as xs:string) {
  let $pathToLastPit := $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]//*[name()=$lastPit]/numOfSeeds/text()
  let $pathToOppositePit := $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]//*[name()=$oppositePit]/numOfSeeds/text()
  return (replace value of node $pathToLastPit with "0", replace value of node $pathToOppositePit with "0")
};
