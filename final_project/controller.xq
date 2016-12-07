xquery version "1.0";

module namespace c = "kalahMancala/controller";

declare variable $c:mancalaStartScreen := doc("startScreen.html");

(: Display the start screen to the player :)
declare %rest:path("/kalahMancala") %rest:GET function c:start() {
  $c:mancalaStartScreen
};