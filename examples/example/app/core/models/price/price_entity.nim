import price_value_objects


type Price* = ref object

proc newPrice*():Price =
  return Price()
