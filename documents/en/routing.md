Routing
===
[back](../../README.md)

Routing is written in `main.nim`. it is the entrypoint file of Basolato.
```nim
import basolato
import app/controllers/some_controller


let ROUTES = @[
  Route.get("/", some_controller.index),
  Route.post("/", some_controller.create)
]

serve(ROUTES)
```

Table of Contents

<!--ts-->
   * [Routing](#routing)
      * [HTTP_Verbs](#http_verbs)
      * [Routing group](#routing-group)
      * [URL Params](#url-params)

<!-- Added by: root, at: Fri Dec 31 11:49:21 UTC 2021 -->

<!--te-->


## HTTP_Verbs
Following HTTP Verbs are valid.

|verb|explanation|
|---|---|
|get|Gets list of resources.|
|post|Creates new resource.|
|put|Updates single resource.|
|patch|Updates single resource.|
|delete|Deletes single resource.|
|head|Gets the same response but without response body.|
|options|Gets list of response headers before post/put/patch/delete/ access by client API software such as [Axios/JavaScript](https://github.com/axios/axios) and [Curl/sh](https://curl.haxx.se/).|
|trace|Performs a message loop-back test along the path to the target resource, providing a useful debugging mechanism.|
|connect|Starts two-way communications with the requested resource. It can be used to open a tunnel.|

## Routing group
```nim
import basolato
import app/controllers/some_controller
import app/controllers/dashboard_controller


let ROUTES = @[
  Route.get("/", some_controller.index),
  Route.group("/dashboard", @[
    Route.get("/url1", dashboard_controller.url1),
    Route.get("/url2", dashboard_controller.url2)
  ])
]
```
`/dashboard/url1` and `/dashboard/url2` are available.

## URL Params
Basolato can specify url params with type of `int` and `str`

```nim
import basolato
import app/controllers/some_controller


let ROUTES = @[
  Route.get("/{id:int}", some_controller.show),
  Route.get("/{name:str}", some_controller.showByName)
]
```

|request URL|Called controller|
|---|---|
|`/1`|some_controller.show|
|`/100`|some_controller.show|
|`/john`|some_controller.showByName|
|`/1/john`|not match and responde 404|
