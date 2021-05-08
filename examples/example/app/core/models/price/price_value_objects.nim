import times
import timezones

type Rate* = ref object
  value:float

proc newRate*(value:float):Rate =
  result = new Rate
  result.value = value

proc get*(self:Rate):float =
  return self.value


type Description* = ref object
  value:string

proc newDescription*(value:string):Description =
  result = new Description
  result.value = value

proc `$`*(self:Description):string =
  return self.value


type FetchTime* = ref object
  value:DateTime

proc newFetchTime*(value:string):FetchTime =
  result = new FetchTime
  result.value = value.parse("yyyy-MM-dd'T'HH:mm:sszzz")

proc `$`*(self:FetchTime):string =
  let zone = tz("+09:00")
  let timeFormat = initTimeFormat("yyyy'年'M'月'd'日'HH'時'mm'分'")
  return self.value.inZone(zone).format(timeFormat)
