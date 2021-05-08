import ../price_value_objects
import ../price_repository_interface
import usd_entity


type UsdService* = ref object
  repository: IUsdRepository

proc newUsdService*(repository:IPriceRepository):UsdService =
  return UsdService(
    repository: repository
  )
