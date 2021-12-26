type TaskViewModel* = ref object
  id:int
  title:string
  createdName:string
  assignName:string
  startOn:string
  endOn:string
  isDisplayUp:bool
  isDisplayDown:bool
  upId:int
  downId:int
  statusId:int

proc new*(_:type TaskViewModel, id:int, title, createdName, assignName, startOn, endOn:string):TaskViewModel =
  return TaskViewModel(
    id:id,
    title:title,
    createdName:createdName,
    assignName:assignName,
    startOn:startOn,
    endOn:endOn
  )
