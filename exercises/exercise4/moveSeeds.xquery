xquery version "1.0";

declare namespace local = "local";
declare variable $gameInstance := fn:doc("GameInstance.xml")/mancalaGame;

(: React to the move of a player and distribute the required seeds :)
declare updating function local:moveSeeds($house as xs:string?) {
    (: Save the number of seeds in the house and replace it with zero :)
    if (fn:starts-with($house, 'house1')) then (
        let $pathToSeeds := $gameInstance/player1/house1/*[name()=$house]/numOfSeeds/text()
        let $seedsToAdd := local:getNumOfSeedsToAdd($pathToSeeds, 0) - 1
        let $seedsToDistribute := xs:decimal($pathToSeeds) - $seedsToAdd
        return (replace value of node $pathToSeeds with $seedsToAdd, local:distribute($seedsToDistribute, local:getNumberFromTag($house), 1, $seedsToAdd - 1))
    )
    else (
        let $pathToSeeds := $gameInstance/player2/house2/*[name()=$house]/numOfSeeds/text()
        let $seedsToAdd := local:getNumOfSeedsToAdd($pathToSeeds, 0) - 1
        let $seedsToDistribute := xs:decimal($pathToSeeds) - $seedsToAdd
        return (replace value of node $pathToSeeds with $seedsToAdd, local:distribute($seedsToDistribute, local:getNumberFromTag($house), 2, $seedsToAdd - 1))
    )
};

(: It is only allowed to update a node once, therefore calculate the initial number of seeds to add to a pit :)
declare function local:getNumOfSeedsToAdd($numOfSeeds as xs:decimal?, $numOfPitsSet as xs:decimal?) {
    if ($numOfSeeds < 13 - $numOfPitsSet) then (
        let $seedsToAdd := 1
        return $seedsToAdd
    )
    else if ($numOfSeeds < 26 - local:getNumOfPitsSetOffsetRound2($numOfPitsSet)) then (
        let $seedsToAdd := 2
        return $seedsToAdd
    )
    else if ($numOfSeeds < 39 - local:getNumOfPitsSetOffsetRound3($numOfPitsSet)) then (
        let $seedsToAdd := 3
        return $seedsToAdd
    )
    else (
        let $seedsToAdd := 4
        return $seedsToAdd
    )
};

(: Returns the offset for the number of pits set in the second round :)
declare function local:getNumOfPitsSetOffsetRound2($numOfPitsSet as xs:decimal) as xs:decimal? {
    if ($numOfPitsSet = 0) then (
        let $result := 0
        return $result
    )
    else (
        let $result := 2*$numOfPitsSet - 1
        return $result
    )
};

(: Returns the offset for the number of pits set in the third round :)
declare function local:getNumOfPitsSetOffsetRound3($numOfPitsSet as xs:decimal) as xs:decimal? {
    if ($numOfPitsSet = 0) then (
        let $result := 0
        return $result
    )
    else (
        let $result := ($numOfPitsSet - 2)*3 + 2
        return $result
    )
};

(: Returns the number from a tag (eg. house11 -> 11) :)
declare function local:getNumberFromTag($tag as xs:string?) {
    let $number := fn:substring($tag, 6)
    return $number
};

(: Distribute the seeds to move among the pits :)
declare updating function local:distribute($numOfSeeds as xs:decimal?, $previousPit as xs:string?, $player as xs:decimal?, $numOfPitsSet as xs:decimal?) {
    (: Distribute the seeds counter-clockwise :)
    if ($numOfSeeds = 0) then (
        (: Do nothing :)
    )
    else (
        if (fn:starts-with($previousPit, '11')) then (
            (: Current pit - store1 :)
            if ($player = 1) then (
                let $pathToSeeds := $gameInstance/player1/store1/numOfSeeds/text()
                let $seedsToAdd := local:getNumOfSeedsToAdd($numOfSeeds, $numOfPitsSet)
                let $newNumOfSeedsInPit := xs:decimal($pathToSeeds) + $seedsToAdd
                (: Initialized with 20 to get to house21 :)
                let $startingNum := "20"
                return (replace value of node $pathToSeeds with $newNumOfSeedsInPit, local:distribute($numOfSeeds - $seedsToAdd, $startingNum, $player, $numOfPitsSet + 1))
            )
            else (
                (: No seeds should be added to the opponents store :)
                (: Initialized with 20 to get to house21 :)
                let $startingNum := "20"
                return local:distribute($numOfSeeds, $startingNum, $player, $numOfPitsSet)
            )
        )
        else if (fn:starts-with($previousPit, '26')) then (
            (: Current pit - store2 :)
            if ($player = 2) then (
                let $pathToSeeds := $gameInstance/player2/store2/numOfSeeds/text()
                let $seedsToAdd := local:getNumOfSeedsToAdd($numOfSeeds, $numOfPitsSet)
                let $newNumOfSeedsInPit := xs:decimal($pathToSeeds) + $seedsToAdd
                (: Initialized with 17 to get to house16 :)
                let $startingNum := "17"
                return (replace value of node $pathToSeeds with $newNumOfSeedsInPit, local:distribute($numOfSeeds - $seedsToAdd, $startingNum, $player, $numOfPitsSet + 1))
            )
            else (
                (: No seeds should be added to the opponents store :)
                (: Initialized with 17 to get to house16 :)
                let $startingNum := "17"
                return local:distribute($numOfSeeds, $startingNum, $player, $numOfPitsSet)
            )
        )
        else if (fn:starts-with($previousPit, '1')) then (
            (: Current pits - house11 to house16 :)
            let $pitNum := xs:decimal($previousPit) - 1
            let $currentPit := fn:concat('house', $pitNum)
            let $pathToSeeds := $gameInstance/player1/house1/*[name()=$currentPit]/numOfSeeds/text()
            let $seedsToAdd := local:getNumOfSeedsToAdd($numOfSeeds, $numOfPitsSet)
            let $newNumOfSeedsInPit := xs:decimal($pathToSeeds) + $seedsToAdd
            return (replace value of node $pathToSeeds with $newNumOfSeedsInPit, local:distribute($numOfSeeds - $seedsToAdd, local:getNumberFromTag($currentPit), $player, $numOfPitsSet + 1))
        )
        else if (fn:starts-with($previousPit, '2')) then (
            (: Current pits - house21 to house26 :)
            let $pitNum := xs:decimal($previousPit) + 1
            let $currentPit := fn:concat('house', $pitNum)
            let $pathToSeeds := $gameInstance/player2/house2/*[name()=$currentPit]/numOfSeeds/text()
            let $seedsToAdd := local:getNumOfSeedsToAdd($numOfSeeds, $numOfPitsSet)
            let $newNumOfSeedsInPit := xs:decimal($pathToSeeds) + $seedsToAdd
            return (replace value of node $pathToSeeds with $newNumOfSeedsInPit, local:distribute($numOfSeeds - $seedsToAdd, local:getNumberFromTag($currentPit), $player, $numOfPitsSet + 1))
        )
        else ()
    )
};

(: Deal with the last seed :)
(: After moving the seeds trigger a redirect with rest:forward to check the special cases :)
(: Get the last pit (numOfStepsToMove = numOfSeeds mod 13) :)
declare function local:getLastPit($startingPit as xs:string?, $numOfStepsToMove as xs:decimal?, $player as xs:decimal?) {
    if ($numOfStepsToMove mod 13 = 0) then (
        let $lastPit := $startingPit
        return $lastPit
    )
    else if (fn:starts-with($startingPit, 'store1')) then (
        let $nextPit := "house21"
        return local:getLastPit($nextPit, $numOfStepsToMove - 1, $player)
    )
    else if (fn:starts-with($startingPit, 'store2')) then (
        let $nextPit := "house16"
        return local:getLastPit($nextPit, $numOfStepsToMove - 1, $player)
    )
    else if (fn:starts-with($startingPit, 'house11')) then (
        if ($player = 1) then (
            let $nextPit := "store1"
            return local:getLastPit($nextPit, $numOfStepsToMove - 1, $player)
        )
        else (
            let $nextPit := "house21"
            return local:getLastPit($nextPit, $numOfStepsToMove - 1, $player)
        )
    )
    else if (fn:starts-with($startingPit, 'house26')) then (
        if ($player = 2) then (
            let $nextPit := "store2"
            return local:getLastPit($nextPit, $numOfStepsToMove - 1, $player)
        )
        else (
            let $nextPit := "house16"
            return local:getLastPit($nextPit, $numOfStepsToMove - 1, $player)
        )
    )
    else if (fn:starts-with(local:getNumberFromTag($startingPit), '1')) then (
        let $nextPitNum := xs:decimal(local:getNumberFromTag($startingPit)) - 1
        let $nextPit := fn:concat('house', $nextPitNum)
        return local:getLastPit($nextPit, $numOfStepsToMove - 1, $player)
    )
    else (
        let $nextPitNum := xs:decimal(local:getNumberFromTag($startingPit)) + 1
        let $nextPit := fn:concat('house', $nextPitNum)
        return local:getLastPit($nextPit, $numOfStepsToMove - 1, $player)
    )
};


(: Input for testing :)
(:
let $input := "house11"
return local:moveSeeds($input)
:)

let $input := "house11"
return local:getLastPit($input, 13, 1)