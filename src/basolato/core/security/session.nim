import asyncdispatch, json, asynchttpserver, options
import session_db
import cookie

type Session* = ref object
  db: SessionDb

proc genNewSession*(token=""):Future[Session] {.async.} =
  return Session(db:await SessionDb.new(token))

proc new*(typ:type Session, request:Request):Future[Option[Session]] {.async.} =
  let sessionId = Cookies.new(request).get("session_id")
  if await checkSessionIdValid(sessionId):
    return await(genNewSession(sessionId)).some
  else:
    return none(typ)

proc db*(self:Session):SessionDb =
  return self.db

proc getToken*(self:Option[Session]):Future[string] {.async.} =
  if self.isSome:
    return await self.get.db.getToken()
  else:
    return ""

proc set*(self:Option[Session], key, value:string) {.async.} =
  if self.isSome:
    await self.get.db.set(key, value)

proc set*(self:Option[Session], key:string, value:JsonNode) {.async.} =
  if self.isSome:
    await self.get.db.set(key, value)

proc isSome*(self:Option[Session], key:string):Future[bool] {.async.} =
  return self.isSome and await self.get.db.some(key)

proc get*(self:Option[Session], key:string):Future[string] {.async.} =
  if await self.isSome(key):
    return await self.get.db.get(key)
  else:
    return ""

proc delete*(self:Option[Session], key:string) {.async.} =
  if self.isSome:
    await self.get.db.delete(key)

proc destroy*(self:Option[Session]) {.async.} =
  if self.isSome:
    await self.get.db.destroy()
