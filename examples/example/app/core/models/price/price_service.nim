import price_value_objects
import price_repository_interface
import price_entity


type PriceService* = ref object
  repository: IPriceRepository

proc newPriceService*(repository:IPriceRepository):PriceService =
  return PriceService(
    repository: repository
  )
