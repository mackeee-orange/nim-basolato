import json
import ../price_value_objects


type Eur* = ref object
  rate:Rate
  description: Description

proc newEur*(rate:Rate, description:Description):Eur =
  return Eur(rate:rate, description:description)

proc `%`*(self:Eur):JsonNode =
  return %*{
    "rate": self.rate.get(),
    "description": $self.description
  }
