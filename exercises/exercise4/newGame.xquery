xquery version "1.0";
declare namespace local = "local";

declare updating function local:insert(){
    let $a := doc("GameInstanceCollection.xml")/gameInstanceCollection
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

return insert nodes $newGame as first into $a

};


(: Just for testing :)
let $temp := ""
return local:insert()





