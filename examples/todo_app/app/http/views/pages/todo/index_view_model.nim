import json
import ../../layouts/todo/app_bar_view_model

type LoginUser* = ref object
  id:int
  name:string
  auth:int

proc new*(_:type LoginUser, id:int, name:string, auth:int):LoginUser =
  return LoginUser(
    id:id,
    name:name,
    auth:auth
  )

proc isAuth*(self:LoginUser):bool =
  return self.auth < 3

type IndexViewModel* = ref object
  appBarViewModel*:AppBarViewModel
  loginUser*:LoginUser
  data*: JsonNode

proc new*(_:type IndexViewModel, loginUser, data:JsonNode):IndexViewModel =
  return IndexViewModel(
    appBarViewModel: AppBarViewModel.new(loginUser["name"].getStr),
    loginUser: LoginUser.new(
      loginUser["id"].getInt,
      loginUser["name"].getStr,
      loginUser["auth"].getInt,
    ),
    data: data
  )
