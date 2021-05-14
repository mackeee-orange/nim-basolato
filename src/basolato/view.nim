# ==== both =====
import
  templates,
  json,
  random,
  core/utils
export
  templates,
  json

randomize()

proc addXmlChar(dest: var string, c: char) {.inline.} =
  case c
  of '&': add(dest, "&amp;")
  of '<': add(dest, "&lt;")
  of '>': add(dest, "&gt;")
  of '\"': add(dest, "&quot;")
  else: add(dest, c)

proc xmlEncode(s: string): string =
  ## Encodes a value to be XML safe:
  ## * ``"`` is replaced by ``&quot;``
  ## * ``<`` is replaced by ``&lt;``
  ## * ``>`` is replaced by ``&gt;``
  ## * ``&`` is replaced by ``&amp;``
  ## * every other character is carried over.
  result = newStringOfCap(s.len + s.len shr 2)
  for i in 0..len(s)-1: addXmlChar(result, s[i])

func get*(val:JsonNode):string =
  case val.kind
  of JString:
    return val.getStr.xmlEncode
  of JInt:
    return $(val.getInt)
  of JFloat:
    return $(val.getFloat)
  of JBool:
    return $(val.getBool)
  of JNull:
    return ""
  else:
    raise newException(JsonKindError, "val is array")

func get*(val:string|TaintedString):string =
  return val.string.xmlEncode



when not defined(js):
  import
    tables,
    strformat,
    strutils,
    asyncdispatch,
    cgi,
    re,
    # osProc,
    macros
  export
    asyncdispatch,
    re,
    tables
  import
    core/security/client,
    core/security/csrf_token,
    core/request
    # request_validation
  export
    client,
    csrf_token,
    request
    # request_validation


  func old*(params:JsonNode, key:string, default=""):string =
    if params.hasKey(key):
      return params[key].get().xmlEncode
    else:
      return default

  func old*(params:TableRef, key:string, default=""):string =
    if params.hasKey(key):
      return params[key].xmlEncode
    else:
      return default

  func old*(params:Params, key:string, default=""):string =
    if params.hasKey(key):
      return params.getStr(key).xmlEncode
    else:
      return default

  type Css* = ref object
    body:string
    saffix:string

  func newCss*(body, saffix:string):Css =
    return Css(body:body, saffix:saffix)

  func `$`*(self:Css):string =
    return self.body

  func get*(self:Css, name:string):string =
    return name & self.saffix

  when isExistsLibsass():
    import sass
    template style*(typ:string, name, body: untyped):untyped =
      if not ["css", "scss"].contains(typ):
        raise newException(Exception, "style type css/scss is only avaiable")
      let name = (proc():Css =
        var css =
          if typ == "scss":
            compile(body)
          else:
            body
        var matches = newSeq[string]()
        for row in css.findAll(re"\.[\d\w]+"):
          if not matches.contains(row):
            matches.add(row)

        var saffix = "_"
        for _ in 0..9:
          saffix.add(char(rand(int('a')..int('z'))))

        for match in matches:
          css = css.replace(match, match & saffix)
        let cssBody = "<style type=\"text/css\">\n" & css & "</style>"
        return newCss(cssBody, saffix)
      )()
  else:
    template style*(typ:string, name, body: untyped):untyped =
      if typ != "css": raise newException(Exception, "You can use only css for the style type.\nTo use scss, please install libsass.\nhttps://github.com/sass/libsass")
      let name = (proc():Css =
        var saffix = "_"
        for _ in 0..9:
          saffix.add(char(rand(int('a')..int('z'))))

        var css = body
        var matches = newSeq[string]()
        for row in css.findAll(re"\.[\d\w]+"):
          if not matches.contains(row):
            matches.add(row)

        for match in matches:
          css = css.replace(match, match & saffix)
        let cssBody = "<style type=\"text/css\">\n" & css & "</style>"
        return newCss(cssBody, saffix)
      )()