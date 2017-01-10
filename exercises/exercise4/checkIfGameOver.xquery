xquery version "1.0";

declare namespace local = "local";
declare variable $gameInstance := doc("file:///C:/Users/Lovre/Desktop/exercises/exercise3/GameInstance.xml")/mancalaGame;

declare function local:countSeedsOfPit ($player as xs:string, $house as xs:string) as xs:double {
    let $seeds := $gameInstance/*[name()=$player]/*[name()=$house]//numOfSeeds
    return fn:sum(data($seeds))
};

(:declare updating function local:removeSeedsFromHouses($player as xs:string, $house as xs:string) {
    for $houses in $gameInstance/*[name()=$player]/*[name()=$house]
    let $pathToSeeds := $houses//numOfSeeds
    return (replace value of node $pathToSeeds with 0)
}; :)

declare updating function local:removeSeedsFromPit($housepit as xs:string) {
    if ($housepit = "house1") then (
        let $housepit := $housepit
        return (local:removeSeedsFromSingleHouse("player1", $housepit, "house11"), local:removeSeedsFromSingleHouse("player1", $housepit, "house12"), 
        local:removeSeedsFromSingleHouse("player1", $housepit, "house13"), local:removeSeedsFromSingleHouse("player1", $housepit, "house14"), 
        local:removeSeedsFromSingleHouse("player1", $housepit, "house15"), local:removeSeedsFromSingleHouse("player1", $housepit, "house16")) 
    ) else if ($housepit = "house2") then (
        let $housepit := $housepit
        return (local:removeSeedsFromSingleHouse("player2", $housepit, "house21"), local:removeSeedsFromSingleHouse("player2", $housepit, "house22"), 
        local:removeSeedsFromSingleHouse("player2", $housepit, "house23"), local:removeSeedsFromSingleHouse("player2", $housepit, "house24"), 
        local:removeSeedsFromSingleHouse("player2", $housepit, "house25"), local:removeSeedsFromSingleHouse("player2", $housepit, "house26"))
    ) else (
    (: do nothing :)
    )
}; 

declare updating function local:removeSeedsFromSingleHouse($player as xs:string, $housepit as xs:string, $house as xs:string) {
    let $pathToSeeds := $gameInstance/*[name()=$player]/*[name()=$housepit]/*[name()=$house]/numOfSeeds
    return (replace value of node $pathToSeeds with 0)
};

declare updating function local:moveSeedsToStore($player as xs:string, $store as xs:string) {
if ($store = "store1") then (
    let $pathToStore := $gameInstance/*[name()=$player]/*[name()=$store]/numOfSeeds
    let $updatedValue := data($pathToStore) + local:countSeedsOfPit ("player1", "house1")
    return (replace value of node $pathToStore with $updatedValue)
) else if ($store = "store2") then (
    let $pathToStore := $gameInstance/*[name()=$player]/*[name()=$store]/numOfSeeds
    let $updatedValue := data($pathToStore) + local:countSeedsOfPit ("player2", "house2")
    return (replace value of node $pathToStore with $updatedValue)
) else (
    (: do nothing :)
)}; 

(:declare updating function local:setGameOverToOne(){
    let $gameOver := $gameInstance/gameOver
    return (replace value of node $gameOver with 1) 
}; :)

declare updating function local:checkIfGameOver() {
    if (local:countSeedsOfPit('player1', 'house1') = 0) then (
        let $gameOver := $gameInstance/gameOver
        return (replace value of node $gameOver with 1, local:moveSeedsToStore("player2", "store2"), local:removeSeedsFromPit("house2"))
    )   
    else if (local:countSeedsOfPit('player2', 'house2') = 0) then (
        let $gameOver := $gameInstance/gameOver
        return (replace value of node $gameOver with 1, local:moveSeedsToStore("player1", "store1"), local:removeSeedsFromPit("house1"))
    ) 
    else (
        (: do nothing :)
    )
};


let $test := ""
return local:checkIfGameOver()