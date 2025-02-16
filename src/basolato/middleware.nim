import asynchttpserver, asyncdispatch, strutils, tables
export asynchttpserver
import core/base, core/route, core/header, core/response,
  core/security/cookie, core/security/session_db, core/security/csrf_token, core/security/context
export base, route, cookie, header, response, context

type MiddlewareResult* = ref object
  hasError: bool
  message: string

func hasError*(self:MiddlewareResult):bool =
  return self.hasError

func message*(self:MiddlewareResult):string =
  return self.message

func next*(status:HttpCode=HttpCode(200), body="", headers:HttpHeaders=newHttpHeaders()):Response =
  return Response(status:status, body:body, headers:headers)

proc checkCsrfToken*(request:Request, params:Params):Future[MiddlewareResult] {.async.} =
  result = MiddlewareResult()
  if request.reqMethod == HttpPost and not request.path.contains("api/"):
    try:
      if not params.hasKey("csrf_token"):
        raise newException(Exception, "csrf token is missing")
      let token = params.getStr("csrf_token")
      discard CsrfToken.new(token).checkCsrfTimeout()
    except:
      result.hasError = true
      result.message = getCurrentExceptionMsg()

proc checkSessionId*(request:Request):Future[MiddlewareResult] {.async.} =
  ## Check session id in cookie is valid.
  result = MiddlewareResult()
  if request.httpMethod != HttpOptions:
    let cookie = Cookies.new(request)
    try:
      if not cookie.hasKey("session_id"):
        raise newException(Exception, "Missing session id")
      let sessionId = cookie.get("session_id")
      if sessionId.len == 0:
        raise newException(Exception, "Session id is empty")
      if not await checkSessionIdValid(sessionId):
        raise newException(Exception, "Invalid session id")
    except:
      result.hasError = true
      result.message = getCurrentExceptionMsg()
