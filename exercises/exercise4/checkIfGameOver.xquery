xquery version "1.0";

declare namespace local = "local";
declare variable $gameInstance := fn:doc("GameInstance.xml")/mancalaGame;

declare function local:countSeeds1 () {
    for $seeds in $gameInstance/player1/house1/numOfSeeds
    return fn:sum($seeds)
};

declare function local:countSeeds2 () {
    for $seeds in $gameInstance/player2/house2/numOfSeeds
    return fn:sum($seeds)
}; 



declare updating function local:checkIfGameOver() {
    if (local:countSeeds1() = 0) then (
        let $gameOver := 1
        return $gameOver
        (: TODO: moveSeeds to Kalaha :) 
    )   
    else if (local:countSeeds2 () = 0) then (
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