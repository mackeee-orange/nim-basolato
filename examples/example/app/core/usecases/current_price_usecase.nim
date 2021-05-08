import httpclient, json, asyncdispatch

type CurrentPriceUsecase* = ref object

proc newCurrentPriceUsecase*():CurrentPriceUsecase =
  return CurrentPriceUsecase()

proc get*(self:CurrentPriceUsecase):Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  let respStr = await client.getContent("https://api.coindesk.com/v1/bpi/currentprice.json")
  echo respStr
  return respStr.parseJson()
