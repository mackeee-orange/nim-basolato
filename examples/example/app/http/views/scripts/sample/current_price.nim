import dom, jsffi, json
import ajax
import templates
import ../../layouts/sample/current_price/component_view


proc print(str:cstring) {.exportc.} =
  echo str

proc fetchCurrency() {.exportc.} =
  var req = newXmlHttpRequest()
  req.open("GET", "https://api.coindesk.com/v1/bpi/currentprice.json")
  req.send()

  req.onreadystatechange = proc(e:Event) =
    if req.readyState == rsDONE and req.status == 200:
      let resp = parseJson($req.responseText)

      let price = %*{
        "usd": {
          "rate": resp["bpi"]["USD"]["rate_float"].getFloat,
          "description": resp["bpi"]["USD"]["description"].getStr
        },
        "gbp": {
          "rate": resp["bpi"]["GBP"]["rate_float"].getFloat,
          "description": resp["bpi"]["GBP"]["description"].getStr
        },
        "eur": {
          "rate": resp["bpi"]["EUR"]["rate_float"].getFloat,
          "description": resp["bpi"]["EUR"]["description"].getStr
        },
        "fetchTime": resp["time"]["updatedISO"].getStr
      }
      document.getElementById("component").innerHTML = componentView(price)
