import std/jsfetch

proc print(str:cstring) {.exportc.} =
  echo str

proc fetch(httpMethod, url:string) {.importc: "fetch".}


proc fetchCurrency() {.exportc.} =
  fetch("get", "https://api.coindesk.com/v1/bpi/currentprice.json")
