xquery version "1.0";

module namespace c = "kalahMancala/controller";

declare variable $c:mancalaStartScreen := doc("startScreen.html");
declare variable $c:gameInstanceCollection := db:open("KalahMancala");



(: Display the start screen to the player :)
declare %rest:path("/kalahMancala") %rest:GET function c:start() {
  $c:mancalaStartScreen
};



declare %rest:path("/refreshData") %rest:GET updating function c:refreshDatabase(){
let $collection = $c:gameInstanceCollection/gameInstanceCollection


};

declare %rest:path("/newGame") %rest:GET updating function c:newGame(){
    let $collection := $c:gameInstanceCollection/gameInstanceCollection
    let $newGame := 
(<mancalaGame id = "{fn:current-dateTime()}">
    <gameOver>0</gameOver>
        <turnOfPlayerOne>{if((fn:seconds-from-time(xs:time(fn:current-time()))*1000)mod 2 = 0) then 0 else 1}</turnOfPlayerOne>
    <player1>
        <store1>
            <numOfSeeds>0</numOfSeeds>
        </store1>
        <house1>
            <house11>
                <numOfSeeds>4</numOfSeeds>
            </house11>
            <house12>
                <numOfSeeds>4</numOfSeeds>
            </house12>
            <house13>
                <numOfSeeds>4</numOfSeeds>
            </house13>
            <house14>
                <numOfSeeds>4</numOfSeeds>
            </house14>
            <house15>
                <numOfSeeds>4</numOfSeeds>
            </house15>
            <house16>
                <numOfSeeds>4</numOfSeeds>
            </house16>
        </house1>
    </player1>
    <player2>
        <store2>
            <numOfSeeds>0</numOfSeeds>
        </store2>
        <house2>
            <house21>
                <numOfSeeds>4</numOfSeeds>
            </house21>
            <house22>
                <numOfSeeds>4</numOfSeeds>
            </house22>
            <house23>
                <numOfSeeds>4</numOfSeeds>
            </house23>
            <house24>
                <numOfSeeds>4</numOfSeeds>
            </house24>
            <house25>
                <numOfSeeds>4</numOfSeeds>
            </house25>
            <house26>
                <numOfSeeds>4</numOfSeeds>
            </house26>
        </house2>
    </player2>
</mancalaGame>)

return insert nodes $newGame as first into $collection

};

