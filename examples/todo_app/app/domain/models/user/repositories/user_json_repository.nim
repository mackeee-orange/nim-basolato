import options

import ../user_entity
import ../../value_objects

type UserRepository* = ref object

proc newUserRepository*():UserRepository =
  return UserRepository()

proc print*(this:UserRepository, value:string) =
  echo "user_json_repository"

proc find*(this:UserRepository, email:string):Option[User] =
  return some(
    User(
      email: newEmail(email)
    )
  )
