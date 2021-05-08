import ../price_value_objects
import ../price_repository_interface
import gbp_entity


type GbpService* = ref object
  repository: IGbpRepository

proc newGbpService*(repository:IPriceRepository):GbpService =
  return GbpService(
    repository: repository
  )
