import httpclient, json, asyncdispatch
import ../models/price/price_value_objects
import ../models/price/price_entity
import ../models/price/usd/usd_entity
import ../models/price/gbp/gbp_entity
import ../models/price/eur/eur_entity

import basolato/controller

type CurrentPriceUsecase* = ref object

proc newCurrentPriceUsecase*():CurrentPriceUsecase =
  return CurrentPriceUsecase()

proc get*(self:CurrentPriceUsecase):Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  let respStr = await client.getContent("https://api.coindesk.com/v1/bpi/currentprice.json")
  let resp = parseJson(respStr)
  let usd = newUsd(
    newRate( resp["bpi"]["USD"]["rate_float"].getFloat ),
    newDescription( resp["bpi"]["USD"]["description"].getStr )
  )
  let gbp = newGbp(
    newRate( resp["bpi"]["GBP"]["rate_float"].getFloat ),
    newDescription( resp["bpi"]["GBP"]["description"].getStr )
  )
  let eur = newEur(
    newRate( resp["bpi"]["EUR"]["rate_float"].getFloat ),
    newDescription( resp["bpi"]["EUR"]["description"].getStr )
  )
  let fetchTime = newFetchTime(resp["time"]["updatedISO"].getStr)
  let price = newPrice(usd, gbp, eur, fetchTime)
  return %price
