xquery version "1.0";

declare namespace local = "local";
declare variable $gameInstance := fn:doc("GameInstance.xml")/mancalaGame;

declare function local:countSeedsPit1() as xs:double {
    for $seeds in $gameInstance/player1/house1//numOfSeeds
    return fn:sum(fn:number($seeds))
};

declare function local:countSeedsPit2 () as xs:double {
    for $seeds in $gameInstance/player2/house2//numOfSeeds
    return fn:sum(fn:number($seeds))
};

(: TODO
declare updating function local:removeSeedsFromHouses($house as xs:string) {

}; :)

(:TODO
declare updating function local:moveSeedsToKalaha($player as xs:string, $store as xs:string) {
let $seeds:= $gameInstance/$player/$store/numOfSeeds
return 1
}; :)

declare function local:checkIfGameOver() {
    if (local:countSeedsPit1() = 0) then (
        let $gameOver := 1
        return $gameOver
        (: TODO: moveSeeds to Kalaha :) 
    )   
    else if (local:countSeedsPit2() = 0) then (
    let $gameOver := 1
    return $gameOver
    (: TODO: moveSeeds to Kalaha :) 
    ) 
    else (
        let $gameOver := 0
        return $gameOver
    )
};

let $test := ""
return local:checkIfGameOver()