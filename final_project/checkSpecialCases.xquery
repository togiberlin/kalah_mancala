(: THE XQUERY METHODS THAT IMPLEMENT THE SPECIAL RULE WHERE A PLAYER SCORES SEEDS WHEN LAST SEED LANDS IN EMPTY PIT :)

xquery version "1.0" encoding "UTF-8";

declare namespace csc = "kalahMancala/checkSpecialCases";

import module namespace cm = "kalahMancala/common" at "common.xq";
import module namespace ms = "kalahMancala/" at "moveSeeds.xquery";

declare variable $csc:gameInstanceCollection := db:open("KalahMancala");

(: This is the main function which triggers all other helper functions :)
declare function csc:checkSpecialCases($gameId as xs:string?, $house as xs:string?, $numOfStepsToMove as xs:decimal, $currentPlayer) {
    (: Check if last pit is from current player AND last pit was empty before AND opposite pit has any seeds? :)
    if (csc:getIsHouseOfCurrentPlayer(ms:getLastPit($house, $numOfStepsToMove, $currentPlayer), $currentPlayer) and 
        csc:getWasLastPitEmpty($gameId, ms:getLastPit($house, $numOfStepsToMove, $currentPlayer)) and 
        csc:getOppositePitHasSeeds($gameId, ms:getLastPit($house, $numOfStepsToMove, $currentPlayer))) then (
        (: First, fill players store. Then, check if player is eligible for a second turn in a row :)
        if (ms:getLastPit($house, $numOfStepsToMove, $currentPlayer) = "store1" or "store2") then (
            let $currentStore := csc:getCurrentPlayersStore($currentPlayer)
            let $lastPit := ms:getLastPit($house, $numOfStepsToMove, $currentPlayer)
            return csc:fillPlayersStore($gameId, $currentStore, $lastPit), csc:checkPlayersSecondTurn($gameId, $currentStore)
        )
        else (
            (: All checks have passed, move last pit and opposite pit seeds to current players store :)
            let $currentStore := csc:getCurrentPlayersStore($currentPlayer)
            let $lastPit := ms:getLastPit($house, $numOfStepsToMove, $currentPlayer)
            return csc:fillPlayersStore($gameId, $currentStore, $lastPit)
        )
    )
    else (
        (: Do nothing :)
    )
};

(: ---- Getter functions ---- :)
(: Determine, which store is currently relevant :)
declare function csc:getCurrentPlayersStore($currentPlayer as xs:string?) {
    if ($currentPlayer = "player1") then (
        let $result := "store1"
        return $result
    )
    else (
        let $result := "store2"
        return $result
    )
};

(: Determine store seed count of current player :)
declare function csc:getStoreSeedCount($gameId as xs:string?, $currentPlayer as xs:string?) {
    if ($currentPlayer = "player1") then (
        let $result := $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/*[name()=$currentPlayer]/store1/numOfSeeds/text()
        return $result
    )
    else (
        let $result := $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/*[name()=$currentPlayer]/store2/numOfSeeds/text()
        return $result
    )
};

(: Check, if last pit is from the current player :)
declare function csc:getIsHouseOfCurrentPlayer($lastPit as xs:string?, $currentPlayer as xs:string?) {
    if ($currentPlayer = "player1") then
        if (fn:starts-with($lastPit, "house1")) then (
            let $result := true
            return $result
        )
        else (
            let $result := false
            return $result
        )
    else if ($currentPlayer = "player2") then (
        if (fn:starts-with($lastPit, "house2")) then (
            let $result := true
            return $result
        )
        else (
            let $result := false
            return $result
        )
    )
    else (
        let $result := false
        return $result
    )
};

(: Check, if last pit was empty before :)
declare function csc:getWasLastPitEmpty($gameId as xs:string?, $lastPit as xs:string?) {
    if ($csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/*[name()=$lastPit]/numOfSeeds/text() = "1") then (
        let $result := true
        return $result
    )
    else (
        let $result := false
        return $result
    )
};

(: Check, if opposite pit contains any seeds :)
declare function csc:getOppositePitHasSeeds($gameId as xs:string?, $lastPit as xs:string?) {
    if (xs:decimal($csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/*[name()=csc:getOppositePit($lastPit)]/numOfSeeds/text()) > 0) then (
        let $result := true
        return $result
    )
    else (
        let $result := false
        return $result
    )
};

(: Get opposite pit house number :)
declare function csc:getOppositePit($lastPit as xs:string?) {
    if (fn:starts-with($lastPit, "house1")) then (
        let $lastPitNumber := (fn:substring-after($lastPit, "house")) + 10
        return fn:concat("house", $lastPitNumber)
    )
    else if (fn:starts-with($lastPit, "house2")) then (
        let $lastPitNumber := (fn:substring-after($lastPit, "house")) - 10
        return fn:concat("house", $lastPitNumber)
    )
    else (
        (: Do nothing :)
    )
};

(: ---- Setter functions ---- :)
(: Take last seed and opposite seeds, then move them to own seed store :)
declare updating function csc:fillPlayersStore($gameId as xs:string?, $relevantStore as xs:string?, $lastPit as xs:string?) {
    if ($relevantStore = "store1" or "store2") then (
        let $pathToSeeds := $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/*[name()=$relevantStore]/numOfSeeds/text()
        let $newStoreValue := xs:decimal(csc:getStoreSeedCount($gameId, $currentPlayer)) + 
                              xs:decimal($csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/*[name()=$lastPit]/numOfSeeds/text()) + 
                              xs:decimal($csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/*[name()=$oppositePit]/numOfSeeds/text())
        return (replace value of node $pathToSeeds with $newStoreValue, csc:setPitsToZero($gameId, $lastPit))
    )
    else (
        (: Do nothing :)
    )
};

(: After players store is successfully filled, set last pit, opposite pit to zero :)
declare updating function csc:setPitsToZero($gameId as xs:string?, $lastPit as xs:string?) {
    let $pathToLastPit := $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/*[name()=$lastPit]/numOfSeeds/text()
    let $pathToOppositePit := $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/*[name()=csc:getOppositePit($lastPit)]/numOfSeeds/text()
    return (replace value of node $pathToLastPit with "0" and replace value of node $pathToOppositePit with "0")
};

declare updating function csc:checkPlayersSecondTurn($gameId as xs:string?, $currentStore as xs:string?) {
    if ($csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/turnOfPlayerOne/text() = "1") then (
        if ($currentStore = "store1") then (
            replace value of node $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/turnOfPlayerOne with "1"
        )
        else (
            replace value of node $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/turnOfPlayerOne with "0"
        )
    )
    else (
        if ($currentStore = "store2") then (
            replace value of node $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/turnOfPlayerOne with "0"
        )
        else (
            replace value of node $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/turnOfPlayerOne with "1"
        )   
    )
};