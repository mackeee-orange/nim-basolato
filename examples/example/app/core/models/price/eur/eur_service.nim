import ../price_value_objects
import ../price_repository_interface
import eur_entity


type EurService* = ref object
  repository: IEurRepository

proc newEurService*(repository:IPriceRepository):EurService =
  return EurService(
    repository: repository
  )
