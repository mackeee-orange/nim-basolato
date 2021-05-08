import json
import ../price_value_objects


type Gbp* = ref object
  rate:Rate
  description: Description

proc newGbp*(rate:Rate, description:Description):Gbp =
  return Gbp(rate:rate, description:description)

proc `%`*(self:Gbp):JsonNode =
  return %*{
    "rate": self.rate.get(),
    "description": $self.description
  }
