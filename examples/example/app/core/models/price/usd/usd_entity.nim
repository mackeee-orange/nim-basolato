import json
import ../price_value_objects


type Usd* = ref object
  rate:Rate
  description: Description

proc newUsd*(rate:Rate, description:Description):Usd =
  return Usd(rate:rate, description:description)

proc `%`*(self:Usd):JsonNode =
  return %*{
    "rate": self.rate.get(),
    "description": $self.description
  }
