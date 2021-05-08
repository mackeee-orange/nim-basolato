import allographer/query_builder
import ../../core/models/price/value_objects
import ../../core/models/price/price_repository_interface


type PriceRdbRepository* = ref object

proc newPriceRepository*():PriceRdbRepository =
  return PriceRdbRepository()


proc toInterface*(self:PriceRdbRepository):IPriceRepository =
  return ()
