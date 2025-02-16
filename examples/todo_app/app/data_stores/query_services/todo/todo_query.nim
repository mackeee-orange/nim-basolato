import json, asyncdispatch
import interface_implements
import allographer/query_builder
from ../../../../config/database import rdb
import ../../../usecases/todo/todo_query_interface


type TodoQuery* = ref object

func new*(typ:type TodoQuery):TodoQuery =
  typ()

implements TodoQuery, ITodoQuery:
  proc getMasterData(self:TodoQuery):Future[JsonNode]{.async.} =
    let status = await rdb.table("status").get()
    let users = await rdb.table("users").where("auth_id", ">", 1).get()
    return %*{
      "status": status,
      "users": users
    }

  proc todoList(self:TodoQuery):Future[seq[JsonNode]] {.async.} =
    return await rdb.table("todo")
      .select(
        "todo.id",
        "todo.title",
        "todo.created_by as created_id",
        "created_user.name as created_name",
        "todo.assign_to as assign_id",
        "assign_user.name as assign_name",
        "todo.start_on",
        "todo.end_on",
        "todo.status_id",
        "status.name as status",
        "todo.sort"
      )
      .join("users as created_user", "created_user.id", "=", "created_id")
      .join("users as assign_user", "assign_user.id", "=", "assign_id")
      .join("status", "status.id", "=", "todo.status_id")
      .orderBy("todo.sort", Desc)
      .get()
