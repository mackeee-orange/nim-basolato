type Status* = ref object
  id:int
  name:string

proc new*(_:type Status, id:int, name:string):Status =
  return Status(
    id:id,
    name:name
  )

proc id*(self:Status):int =
  return self.id

proc name*(self:Status):string =
  return self.name

type StatusViewModel* = ref object
  status:Status