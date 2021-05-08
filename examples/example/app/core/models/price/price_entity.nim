import json
import price_value_objects
import usd/usd_entity
import gbp/gbp_entity
import eur/eur_entity

type Price* = ref object
  usd:Usd
  gbp:Gbp
  eur:Eur
  fetchTime: FetchTime

proc newPrice*(usd:Usd, gbp:Gbp, eur:Eur, fetchTime:FetchTime):Price =
  return Price(usd:usd, gbp:gbp, eur:eur, fetchTime:fetchTime)

proc `%`*(self:Price):JsonNode =
  return %*{
    "usd": self.usd,
    "gbp": self.gbp,
    "eur": self.eur,
    "fetchTime": $self.fetchTime
  }
