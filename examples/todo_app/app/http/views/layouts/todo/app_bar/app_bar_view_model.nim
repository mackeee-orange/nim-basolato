type AppBarViewModel* = ref object
  name: string

proc new*(_:type AppBarViewModel, name:string):AppBarViewModel =
  return AppBarViewModel(
    name:name
  )

proc name*(self:AppBarViewModel):string =
  return self.name
