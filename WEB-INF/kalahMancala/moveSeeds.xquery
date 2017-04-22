(: THE XQUERY METHODS THAT IMPLEMENT A PLAYERS TURN OF MOVING SEEDS :)

xquery version "3.0" encoding "UTF-8";

module namespace ms = "kalahMancala/moveSeeds";

import module namespace cm = "kalahMancala/common" at "common.xq";

declare variable $ms:gameInstanceCollection := db:open("KalahMancala");

(: React to the move of a player and distribute the required seeds. :)
declare updating function ms:moveSeeds($gameId as xs:string, $house as xs:string) {
  (: Save the number of seeds in the house and replace it with zero. :)
  let $currentPlayer := ms:getCurrentPlayer($gameId)
  let $pathToSeeds := ms:getPathToSeeds($gameId, $house)
  let $seedsToAdd := ms:getNumOfSeedsToAdd($pathToSeeds, 0) - 1
  let $seedsToDistribute := xs:decimal($pathToSeeds) - $seedsToAdd
  return (replace value of node $pathToSeeds with $seedsToAdd,
    ms:distribute($seedsToDistribute, cm:getNumberFromTag($house), $currentPlayer, $seedsToAdd - 1, $gameId),
    db:output(cm:redirectToSpecialCases($gameId, $house, $pathToSeeds, $currentPlayer)))
};

(: Distribute the seeds to move among the pits. :)
declare %private updating function ms:distribute($numOfSeeds as xs:decimal, $previousPit as xs:string, $player as xs:decimal, $numOfPitsSet as xs:decimal, $gameId as xs:string) {
  (: Distribute the seeds counter-clockwise. :)
  if ($numOfSeeds = 0) then (
    (: No seeds to distribute, do nothing, return. :)
  ) else (
    if (fn:starts-with($previousPit, '11')) then (
      (: Current pit - store1. :)
      if ($player = 1) then (
        let $pathToSeeds := ms:getPathToSeeds($gameId, "store1")
        let $seedsToAdd := ms:getNumOfSeedsToAdd($numOfSeeds, $numOfPitsSet)
        let $newNumOfSeedsInPit := xs:decimal($pathToSeeds) + $seedsToAdd
        (: Initialized with 20 to get to house21. :)
        let $startingNum := "20"
        return (replace value of node $pathToSeeds with $newNumOfSeedsInPit,
          ms:distribute($numOfSeeds - $seedsToAdd, $startingNum, $player, $numOfPitsSet + 1, $gameId))
      ) else (
        (: No seeds should be added to the opponents store. :)
        (: Initialized with 20 to get to house21. :)
        let $startingNum := "20"
        return ms:distribute($numOfSeeds, $startingNum, $player, $numOfPitsSet, $gameId)
      )
    ) else if (fn:starts-with($previousPit, '26')) then (
      (: Current pit - store2. :)
      if ($player = 2) then (
        let $pathToSeeds := ms:getPathToSeeds($gameId, "store2")
        let $seedsToAdd := ms:getNumOfSeedsToAdd($numOfSeeds, $numOfPitsSet)
        let $newNumOfSeedsInPit := xs:decimal($pathToSeeds) + $seedsToAdd
        (: Initialized with 17 to get to house16. :)
        let $startingNum := "17"
        return (replace value of node $pathToSeeds with $newNumOfSeedsInPit,
          ms:distribute($numOfSeeds - $seedsToAdd, $startingNum, $player, $numOfPitsSet + 1, $gameId))
      ) else (
        (: No seeds should be added to the opponents store. :)
        (: Initialized with 17 to get to house16. :)
        let $startingNum := "17"
        return ms:distribute($numOfSeeds, $startingNum, $player, $numOfPitsSet, $gameId)
      )
    ) else (
      (: Current pits - house11 to house16 and house21 to house26. :)
      let $currentPit := ms:getCurrentHouseName($previousPit)
      let $pathToSeeds := ms:getPathToSeeds($gameId, $currentPit)
      let $seedsToAdd := ms:getNumOfSeedsToAdd($numOfSeeds, $numOfPitsSet)
      let $newNumOfSeedsInPit := xs:decimal($pathToSeeds) + $seedsToAdd
      return (replace value of node $pathToSeeds with $newNumOfSeedsInPit,
        ms:distribute($numOfSeeds - $seedsToAdd, cm:getNumberFromTag($currentPit), $player, $numOfPitsSet + 1, $gameId))
    )
  )
};

(: GETTERS :)

(: Returns the name of the current house, where the seeds have to be distributed to. :)
declare %private function ms:getCurrentHouseName($previousPit as xs:string) as xs:string {
  if (fn:starts-with($previousPit, '1')) then (
    let $houseNum := xs:decimal($previousPit) - 1
    return fn:concat('house', $houseNum)
  ) else (
    let $houseNum := xs:decimal($previousPit) + 1
    return fn:concat('house', $houseNum)
  )
};

(: Returns the path to the seeds of a pit. :)
declare %private function ms:getPathToSeeds($gameId as xs:string, $pit as xs:string) {
  if (fn:starts-with($pit, 'house1')) then (
    $ms:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/player1/house1/*[name()=$pit]/numOfSeeds/text()
  ) else if (fn:starts-with($pit, 'house2')) then (
    $ms:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/player2/house2/*[name()=$pit]/numOfSeeds/text()
  ) else if (fn:starts-with($pit, 'store1')) then (
    $ms:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/player1/*[name()=$pit]/numOfSeeds/text()
  ) else (
    $ms:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/player2/*[name()=$pit]/numOfSeeds/text()
  )
};

(: Returns the number of the current player (player1 -> 1; player2 -> 2). :)
declare %private function ms:getCurrentPlayer($gameId as xs:string) as xs:decimal {
  if ($ms:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/turnOfPlayerOne/text() = 1) then (1) else (2)
};

(: It is only allowed to update a node once, therefore calculate the initial number of seeds to add to a pit (max 4 rounds). :)
declare %private function ms:getNumOfSeedsToAdd($numOfSeeds as xs:decimal, $numOfPitsSet as xs:decimal) as xs:decimal {
  if ($numOfSeeds < 13 - $numOfPitsSet) then (
    (: One round. :)
    1
  ) else if ($numOfSeeds < 26 - ms:getNumOfPitsSetOffsetRound2($numOfPitsSet)) then (
    (: Two rounds. :)
    2
  ) else if ($numOfSeeds < 39 - ms:getNumOfPitsSetOffsetRound3($numOfPitsSet)) then (
    (: Three rounds. :)
    3
  ) else (
    (: Four rounds. :)
    4
  )
};

(: Returns the offset for the number of pits set in the second round. :)
declare %private function ms:getNumOfPitsSetOffsetRound2($numOfPitsSet as xs:decimal) as xs:decimal {
  if ($numOfPitsSet = 0) then (
    0
  ) else (
    2 * $numOfPitsSet - 1
  )
};

(: Returns the offset for the number of pits set in the third round. :)
declare %private function ms:getNumOfPitsSetOffsetRound3($numOfPitsSet as xs:decimal) as xs:decimal {
  if ($numOfPitsSet = 0) then (
    0
  ) else (
    ($numOfPitsSet - 2) * 3 + 2
  )
};
