(: THE XQUERY METHODS THAT IMPLEMENT THE SPECIAL RULE WHERE A PLAYER SCORES SEEDS WHEN LAST SEED LANDS IN EMPTY PIT :)

xquery version "1.0" encoding "UTF-8";

declare namespace csc = "kalahMancala/checkSpecialCases";

import module namespace cm = "kalahMancala/common" at "common.xq";

declare variable $csc:gameInstanceCollection := db:open("KalahMancala");

declare variable $currentPlayer := csc:getCurrentPlayer();

(: This is the main function which triggers all other helper functions :)
declare function csc:checkSpecialCases($lastPit as xs:string?) {
    (: Check if last pit is from current player AND last pit was empty before AND opposite pit has any seeds? :)
    if (csc:getIsHouseOfCurrentPlayer($lastPit, $currentPlayer) and csc:getWasLastPitEmpty($lastPit) and csc:getOppositePitHasSeeds($lastPit)) then (
        (: First, fill players store. Then, check if player is eligible for a second turn in a row :)
        if ($lastPit = "store1" or "store2") then (
            let $currentStore := csc:getCurrentPlayersStore($currentPlayer)
            return csc:fillPlayersStore($currentStore), csc:checkPlayersSecondTurn($currentStore)
        )
        else (
            (: All checks have passed, move last pit and opposite pit seeds to current players store :)
            let $currentStore := csc:getCurrentPlayersStore($currentPlayer)
            return csc:fillPlayersStore($currentStore)
        )
    )
    else (
        (: Do nothing :)
    )
};

(: ---- Getter functions ---- :)
(: Determine current player :)
declare function csc:getCurrentPlayer() { 
    if ($csc:gameInstanceCollection/gameInstanceCollection/turnOfPlayerOne/text() = "1") then (
        let $result := "player1"
        return $result
    )
    else (
        let $result := "player2"
        return $result
    )
};

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
declare function csc:getStoreSeedCount($currentPlayer as xs:string?) {
    if ($currentPlayer = "player1") then (
        let $result := $csc:gameInstanceCollection/gameInstanceCollection/*[name()=$currentPlayer]/store1
        return $result
    )
    else (
        let $result := $csc:gameInstanceCollection/gameInstanceCollection/*[name()=$currentPlayer]/store2
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
declare function csc:getWasLastPitEmpty($lastPit as xs:string?) {
    if ($lastPit/numOfSeeds/text() = "1") then (
        let $result := true
        return $result
    )
    else (
        let $result := false
        return $result
    )
};

(: Check, if opposite pit contains any seeds :)
declare function csc:getOppositePitHasSeeds($lastPit as xs:string?) {
    if ($csc:gameInstanceCollection/gameInstanceCollection/*[name()=csc:getOppositePit($lastPit)]/numOfSeeds/text() > 0) then (
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
        let $houseNumber := (fn:substring-after($lastPit, "house")) + 10
        return fn:concat("house", $houseNumber)
    )
    else if (fn:starts-with($lastPit, "house2")) then (
        let $houseNumber := (fn:substring-after($lastPit, "house")) - 10
        return fn:concat("house", $houseNumber)
    )
    else (
        (: Do nothing :)
    )
};

(: ---- Setter functions ---- :)
(: Take last seed and opposite seeds, then move them to own seed store :)
declare updating function csc:fillPlayersStore($relevantStore as xs:string?, $lastPit as xs:string?) {
    if ($relevantStore = "store1" or "store2") then (
        let $pathToSeeds := $csc:gameInstanceCollection/gameInstanceCollection/*[name()=$relevantStore]/numOfSeeds/text()
        let $newStoreValue := *[name()=csc:getStoreSeedCount($currentPlayer)] + $csc:gameInstanceCollection/*[name()=$lastPit]/numOfSeeds/text() + $csc:gameInstanceCollection/*[name()=$oppositePit]/numOfSeeds/text()
        return (replace value of node $pathToSeeds with $newStoreValue, csc:setPitsToZero($lastPit))
    )
    else (
        (: Do nothing :)
    )
};

(: After players store is successfully filled, set last pit, opposite pit to zero :)
declare updating function csc:setPitsToZero($lastPit as xs:string?) {
    let $pathToLastPit := $csc:gameInstanceCollection/*[name()=$lastPit]/numOfSeeds/text()
    let $pathToOppositePit := $csc:gameInstanceCollection/gameInstanceCollection/*[name()=csc:getOppositePit($lastPit)]/numOfSeeds/text()
    return (replace value of node $pathToLastPit with "0" and replace value of node $pathToOppositePit with "0")
};

declare updating function csc:checkPlayersSecondTurn($currentStore as xs:string?) {
    if ($csc:gameInstanceCollection/gameInstanceCollection/mancalaGame/turnOfPlayerOne = "1") then (
        if ($currentStore = "store1") then (
            replace value of node $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame/turnOfPlayerOne with "1"
        )
        else (
            replace value of node $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame/turnOfPlayerOne with "0"
        )
    )
    else (
        if ($currentStore = "store2") then (
            replace value of node $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame/turnOfPlayerOne with "0"
        )
        else (
            replace value of node $csc:gameInstanceCollection/gameInstanceCollection/mancalaGame/turnOfPlayerOne with "1"
        )   
    )
};

(: For testing purposes 
let $lastPit := "house26"
return csc:checkSpecialCases($lastPit)
:)