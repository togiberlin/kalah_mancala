(: THE XQUERY METHODS IMPLEMENTING THE CHECK IF THE GAME IS OVER :)

xquery version "1.0" encoding "UTF-8";

module namespace go = "kalahMancala/checkGameOver";

declare variable $go:gameInstanceCollection := db:open("KalahMancala");

(: Checks if the game is over and updates the gameOver node, moves seeds to the store and removes seeds from the pit of the losing player :)
declare updating function go:checkGameOver($gameId as xs:string) {
    if (go:countSeedsOfPit($gameId, 'player1', 'house1') = 0) then (
        let $gameOver := $go:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/gameOver/text()
        return (replace value of node $gameOver with 1, go:moveSeedsToStore($gameId, "player2", "store2"), go:removeSeedsFromPit($gameId, "house2"))
    )   
    else if (go:countSeedsOfPit($gameId, 'player2', 'house2') = 0) then (
        let $gameOver := $go:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/gameOver/text()
        return (replace value of node $gameOver with 1, go:moveSeedsToStore($gameId, "player1", "store1"), go:removeSeedsFromPit($gameId, "house1"))
    ) 
    else (
        (: do nothing :)
    )
};

(: Moves the seeds of a pit to the respective store :)
declare updating function go:moveSeedsToStore($gameId as xs:string, $player as xs:string, $store as xs:string) {
if ($store = "store1") then (
    let $pathToStore := $go:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/*[name()=$player]/*[name()=$store]/numOfSeeds/text()
    let $updatedValue := data($pathToStore) + go:countSeedsOfPit ($gameId, "player1", "house1")
    return (replace value of node $pathToStore with $updatedValue)
) else if ($store = "store2") then (
    let $pathToStore := $go:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/*[name()=$player]/*[name()=$store]/numOfSeeds/text()
    let $updatedValue := data($pathToStore) + go:countSeedsOfPit ($gameId, "player2", "house2")
    return (replace value of node $pathToStore with $updatedValue)
) else (
    (: do nothing :)
)}; 

(: Removes seeds from a single house :)
declare updating function go:removeSeedsFromSingleHouse($gameId as xs:string, $player as xs:string, $housepit as xs:string, $house as xs:string) {
    let $pathToSeeds := $go:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/*[name()=$player]/*[name()=$housepit]/*[name()=$house]/numOfSeeds/text()
    return (replace value of node $pathToSeeds with 0)
};

(: Removes all seeds of the respective pit :)
declare updating function go:removeSeedsFromPit($gameId as xs:string, $housepit as xs:string) {
    if ($housepit = "house1") then (
        let $housepit := $housepit
        return (go:removeSeedsFromSingleHouse($gameId, "player1", $housepit, "house11"), go:removeSeedsFromSingleHouse($gameId, "player1", $housepit, "house12"), 
                go:removeSeedsFromSingleHouse($gameId, "player1", $housepit, "house13"), go:removeSeedsFromSingleHouse($gameId, "player1", $housepit, "house14"), 
                go:removeSeedsFromSingleHouse($gameId, "player1", $housepit, "house15"), go:removeSeedsFromSingleHouse($gameId, "player1", $housepit, "house16")) 
    ) else if ($housepit = "house2") then (
        let $housepit := $housepit
        return (go:removeSeedsFromSingleHouse($gameId, "player2", $housepit, "house21"), go:removeSeedsFromSingleHouse($gameId, "player2", $housepit, "house22"), 
                go:removeSeedsFromSingleHouse($gameId, "player2", $housepit, "house23"), go:removeSeedsFromSingleHouse($gameId, "player2", $housepit, "house24"), 
                go:removeSeedsFromSingleHouse($gameId, "player2", $housepit, "house25"), go:removeSeedsFromSingleHouse($gameId, "player2", $housepit, "house26"))
    ) else (
    (: do nothing :)
    )
}; 

(: GETTERS :)

(: Returns the number of seeds of a house pit :)
declare function go:countSeedsOfPit ($gameId as xs:string, $player as xs:string, $house as xs:string) as xs:double {
    let $seeds := $go:gameInstanceCollection/gameInstanceCollection/mancalaGame[@id=$gameId]/*[name()=$player]/*[name()=$house]//numOfSeeds/text()
    return fn:sum(data($seeds))
};