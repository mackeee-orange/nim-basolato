import json
import task/task_view_model

type StatusViewModel* = ref object
  name:string
  taskViewModels: seq[TaskViewModel]

proc new*(_:type StatusViewModel, name:string, data:JsonNode):StatusViewModel =
  let statusColumn = data["transaction"][name]
  return StatusViewModel(
    name:name,
    taskViewModel:taskViewModel
  )

proc name*(self:StatusViewModel):string =
  return self.name

proc taskViewModels*(self:TaskViewModel):seq[TaskViewModel] =
  return self.taskViewModels
