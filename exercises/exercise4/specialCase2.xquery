xquery version "1.0";

declare namespace local="local";

declare updating function local:checkSpecialCasesIf2 ($id as xs:string?)
{
let $game := doc("file:///Users/nickschneider/xml_lab/exercises/exercise3/GameInstance.xml")

return if ($game/mancalaGame/turnOfPlayerOne = "1")
       then (if ($id = "store1")
              then (replace value of node $game/mancalaGame/turnOfPlayerOne with "1")
             else (replace value of node $game/mancalaGame/turnOfPlayerOne with "0"))
        else (if ($id = "store2")
              then (replace value of node $game/mancalaGame/turnOfPlayerOne with "0")
              else (replace value of node $game/mancalaGame/turnOfPlayerOne with "1")   )
};

let $temp := ""
return local:checkSpecialCasesIf2("store1")