ヘッダー
===
[戻る](../../README.md)

コンテンツ

<!--ts-->
   * [ヘッダー](#ヘッダー)
      * [リクエストヘッダー](#リクエストヘッダー)
      * [レスポンスヘッダー](#レスポンスヘッダー)
         * [Header型](#header型)
         * [コントローラーでレスポンスにヘッダーを設定する](#コントローラーでレスポンスにヘッダーを設定する)

<!-- Added by: root, at: Fri Dec 31 11:51:04 UTC 2021 -->

<!--te-->

## リクエストヘッダー
リクエストヘッダーを取得するには、`request.headers`を使ってください。

middleware/check_login.nim
```nim
import basolato/middleware

proc hasLoginId*(request:Request, params:Params):Future[Response] {.async.} =
  try:
    let loginId = request.headers["X-login-id"]
  except:
    raise newException(Error403, "Can't get login id")
```

app/controllers/sample_controller.nim
```nim
proc index*(request:Request, params:Params):Future[Response] {.async.} =
  let loginId = request.headers["X-login-id"]
```

## レスポンスヘッダー
### Header型
`newHttpHeaders()`は`openArray[tuple[key: string, val: string]]`から`HttpHeaders`オブジェクトを作ります。  
https://nim-lang.org/docs/httpcore.html#HttpHeaders

```nim
let headers = {
  "Strict-Transport-Security": "max-age=63072000, includeSubdomains",
  "X-Frame-Options": "SAMEORIGIN",
  "X-XSS-Protection": "1, mode=block",
  "X-Content-Type-Options": "nosniff",
  "Referrer-Policy": "no-referrer, strict-origin-when-cross-origin",
  "Cache-control": "no-cache, no-store, must-revalidate",
  "Pragma": "no-cache",
}.newHttpHeaders()
```


### コントローラーでレスポンスにヘッダーを設定する
`newHeaders()`関数で`Header`型のインスタンスを作り、`add`関数で値を追加し、最後に`render`関数の末尾に置きます。

```nim
proc index*(request:Request, params:Params):Future[Response] {.async.} =
  var header = newHeaders()
  headers.add("Controller-Header-Key1", ["Controller-Header-Val1", "Controller-Header-Val2"])
  headers.add("Controller-Header-Key2", ["val1", "val2", "val3"])
  return render("with header", header)
```
