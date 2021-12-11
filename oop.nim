# type User* = ref object
#   name:string

# proc setName(self:var User, name:string) =
#   self.name = name

# proc getName(self:User):string =
#   self.name

# var user = User()
# user.setName("taro")
# echo user.getName()
# user.setName("jiro")
# echo user.getName()


# type Parent = ref object of RootObj
#   name:string

# proc new(self:typedesc, name:string):self.type =
#   self.type(name:name)


# type Child = ref object of Parent

# proc newChild(name:string):Child =
#   Child.new(name)

# proc getName(self:Child): string =
#   self.name

# echo newChild("taro").getName()


import interface_implements

type Parent = ref object

proc new(_:type Parent):Parent =
  return Parent()

proc parentMethod(self:Parent) =
  echo "parent method"

type IParent = tuple
  parentMethod:proc()



type Child = ref object
  parent:Parent

implements Child, IParent:
  proc parentMethod(self:Child) =
    self.parent.parentMethod()

proc new(_:type Child):Child =
  return Child(
    parent: Parent.new()
  )

proc childMethod(self:Child) =
  echo "child method"


block:
  let child = Child.new()
  child.parentMethod()
  child.childMethod()
