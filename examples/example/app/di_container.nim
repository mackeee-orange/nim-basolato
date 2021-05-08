# query service
import repositories/query_services/query_service_interface
import repositories/query_services/query_service
# js_output
import core/models/js_output/js_output_repository_interface
import repositories/js_output/js_output_rdb_repository
# Price
import core/models/Price/Price_repository_interface
import repositories/Price/Price_rdb_repository
# price
import core/models/price/price_repository_interface
import repositories/price/price_rdb_repository

type DiContainer* = tuple
  queryService: IQueryService
  js_outputRepository: IJsOutputRepository
  PriceRepository: IPriceRepository
  priceRepository: IPriceRepository

proc newDiContainer():DiContainer =
  return (
    queryService: newQueryService().toInterface(),
    js_outputRepository: newJsOutputRepository().toInterface(),
    PriceRepository: newPriceRepository().toInterface(),
    priceRepository: newPriceRepository().toInterface(),
  )

let di* = newDiContainer()
