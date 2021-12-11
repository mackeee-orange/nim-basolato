type Todo* = ref object
  id:int
  title:string
  createdName:string
  assignName:string
  startOn:string
  endOn:string

proc new*(_:type Todo, id:int, title, createdName, assignName, startOn, endOn:string):Todo =
  return Todo(
    id:id,
    title:title,
    createdName:createdName,
    assignName:assignName,
    startOn:startOn,
    endOn:endOn
  )

type TaskViewModel* = ref object
