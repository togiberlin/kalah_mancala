(: THE COMMONLY USED XQUERY METHODS :)

xquery version "1.0" encoding "UTF-8";

module namespace cm = "kalahMancala/common";

(: Redirect to the XML to XHTML transformator :)
declare function cm:redirectToTransformator($gameId as xs:string) {
    let $transformatorURL := fn:concat("http://localhost:8984/gxf/transform/", $gameId)
    return web:redirect($transformatorURL)
};

(: Generate a timestamp as an ID for the game instance. :)
declare function cm:generateGameId() as xs:string {
  let $dateTime := xs:string(fn:current-dateTime())
  return fn:translate($dateTime, '&#043;', '')
};