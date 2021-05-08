import ../price_value_objects
import price_entity
import ../price_repository_interface


type PriceService* = ref object
  repository: IPriceRepository

proc newPriceService*(repository:IPriceRepository):PriceService =
  return PriceService(
    repository: repository
  )
