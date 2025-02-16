View
===
[back](../../README.md)

Table of Contents

<!--ts-->
   * [View](#view)
      * [Introduction](#introduction)
      * [XSS](#xss)
         * [API](#api)
         * [Sample](#sample)
      * [Component style design](#component-style-design)
         * [JavaScript](#javascript)
         * [CSS](#css)
         * [SCSS](#scss)
         * [API](#api-1)
      * [Helper functions](#helper-functions)
         * [Csrf Token](#csrf-token)
         * [old helper](#old-helper)
      * [Other template libraries](#other-template-libraries)
         * [Block component example](#block-component-example)
            * [htmlgen](#htmlgen)
            * [SCF](#scf)
            * [Karax](#karax)

<!-- Added by: root, at: Fri Dec 31 11:50:04 UTC 2021 -->

<!--te-->

## Introduction
Basolato use `nim-templates` as a default template engin. It can be used by importing `basolato/view`.

```nim
import basolato/view

proc baseImpl(content:string): string =
  tmpli html"""
    <html>
      <heade>
        <title>Basolato</title>
      </head>
      <body>
        $(content.get)
      </body>
    </html>
  """

proc indexImpl(message:string): string =
  tmpli html"""
    <p>$(message.get)</p>
  """

proc indexView*(message:string): string =
  baseImpl(indexImpl(message))
```

## XSS
To prevent XSS, **you have to use `get` proc for valiable.** It applies [xmlEncode](https://nim-lang.org/docs/cgi.html#xmlEncode,string) inside.

### API
```nim
proc get*(val:JsonNode):string =

proc get*(val:string):string =
```

### Sample
```nim
title = "This is title<script>alert("aaa")</script>"
params = @["<script>alert("aaa")</script>", "b"].parseJson()
```
```nim
import basolato/view

proc impl(title:string, params:JsonNode):Future[string] {.async.} =
  tmpli html"""
    <h1>$(title.get)</h1>
    <ul>
      $for param in params {
        <li>$(param.get)</li>
      }
    </ul>
  """
```

## Component style design
Basolato view is designed for component oriented design like React and Vue.  
Component is a single chunk of html, JavaScriptand and css, and just a procedure that return html string.

### JavaScript
controller
```nim
import basolato/controller

proc withSscriptPage*(request:Request, params:Params):Future[Response] {.async.} =
  return render(withScriptView())
```

view
```nim
import basolato/view
import ../layouts/application_view


proc impl():string =
  script ["toggle"], script:"""
    <script>
      window.addEventListener('load', ()=>{
        let el = document.getElementById('toggle')
        el.style.display = 'none'
      })

      const toggleOpen = () =>{
        let el = document.getElementById('toggle')
        if(el.style.display == 'none'){
          el.style.display = ''
        }else{
          el.style.display = 'none'
        }
      }
    </script>
  """

  tmpli html"""
    $(script)
    <div>
      <button onclick="toggleOpen()">toggle</button>
      <div id="$(script.element("toggle"))">...content</div>
    </div>
  """

proc withScriptView*():string =
  let title = "Title"
  return applicationView(title, impl())
```

This is compiled to html like this.
```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Title</title>
  </head>
  <body>
    <script>
      window.addEventListener('load', ()=>{
        let el = document.getElementById('toggle_akvcgccoeg')
        el.style.display = 'none'
      })

      const toggleOpen = () =>{
        let el = document.getElementById('toggle_akvcgccoeg')
        if(el.style.display == 'none'){
          el.style.display = ''
        }else{
          el.style.display = 'none'
        }
      }
    </script>
    <div>
      <button onclick="toggleOpen()">toggle</button>
      <div id="toggle_akvcgccoeg">...content</div>
    </div>
  </body>
</html>
```

The selector passed as the first argument of the `script` template will have a random suffix for each component, so multiple components can have the same ID name/class name.

### CSS
controller
```nim
import basolato/controller

proc withStylePage*(request:Request, params:Params):Future[Response] {.async.} =
  return render(withStyleView())
```

view
```nim
import basolato/view


proc impl():string = 
  style "css", style:"""
    <style>
      .background {
        height: 200px;
        width: 200px;
        background-color: blue;
      }

      .background:hover {
        background-color: green;
      }
    </style>
  """

  tmpli html"""
    $(style)
    <div class="$(style.element("background"))"></div>
  """

proc withStyleView*():string =
  let title = "Title"
  return applicationView(title, impl())
```

This is compiled to html like this.
```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Title</title>
  </head>
  <body>
    <style type="text/css">
      .background_jtshlgnucx {
        height: 200px;
        width: 200px;
        background-color: blue;
      }
      .background_jtshlgnucx:hover {
        background-color: green;
      }
    </style>
    <div class="background_jtshlgnucx"></div>
  </body>
</html>
```

`style` template is a useful type for creating per-component style inspired by `CSS-in-JS`.
Styled class names have a random suffix per component, so multiple components can have the same class name.

### SCSS
You can also use SCSS by installing [libsass](https://github.com/sass/libsass/).

```sh
apt install libsass-dev
# or
apk add --no-cache libsass-dev
```

Then you can write style block like this.
```nim
style "scss", style:"""
  <style>
    .background {
      height: 200px;
      width: 200px;
      background-color: blue;

      &:hover {
        background-color: green;
      }
    }
  </style>
"""
```

### API
`script` template crate `Script` type instance in `name` arg variable.
`style` template crate `Css` type instance in `name` arg variable.

```nim
# for JavaScript
template script*(selectors:openArray[string], name, body:untyped):untyped

template script*(name, body:untyped):untyped

proc `$`*(self:Script):string

proc element*(self:Script, name:string):string

# for CSS
template style*(typ:string, name, body: untyped):untyped

proc `$`*(self:Css):string

proc element*(self:Css, name:string):string
```

## Helper functions

### Csrf Token
To send POST request from `form`, you have to set `csrf token`. You can use helper function from `basolato/view`

```nim
import basolato/view

proc index*():string =
  tmpli html"""
    <form>
      $(csrfToken())
      <input type="text", name="name">
    </form>
  """
```

### old helper
If the user's input value is invalid and you want to back the input page and display the previously entered value, you can use `old` helper function.

API
```nim
proc old*(params:JsonNode, key:string):string =

proc old*(params:TableRef, key:string):string =

```

controller
```nim
# get access
proc signinPage*(request:Request, params:Params):Future[Response] {.async.} =
  return render(signinView())

# post access
proc signin*(request:Request, params:Params):Future[Response] {.async.} =
  let email = params.getStr("email")
  try
    ...
  except:
    return render(Http422, signinView(%params))
```

view
```nim
proc impl(params=newJObject()):string =
  tmpli html"""
    <input type="text" name="email" value="$(old(params, "email"))">
    <input type="text" name="password">
  """

proc signinView*(params=newJObject()):string =
  let title = "SignIn"
  return self.applicationView(title, impl(params))
```
It display value if `params` has key `email`, otherwise display empty string.

## Other template libraries
Other libraries which generate HTML can be chosen for Basolato too. However, each library has it's own benefits and drawbacks.  

- [htmlgen](https://nim-lang.org/docs/htmlgen.html)
- [SCF](https://nim-lang.org/docs/filters.html)
- [Karax](https://github.com/pragmagic/karax)
- [nim-templates](https://github.com/onionhammer/nim-templates)

<table>
  <tr>
    <th>Library</th><th>Benefits</th><th>Drawbacks</th>
  </tr>
  <tr>
    <td>htmlgen</td>
    <td>
      <ul>
        <li>Nim standard library</li>
        <li>Easy to use for Nim programmer</li>
        <li>Available to define plural Procedures in one file</li>
      </ul>
    </td>
    <td>
      <ul>
        <li>Cannot use `if` statement and `for` statement</li>
        <li>Maybe difficult to collaborate with designer or markup enginner</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>SCF</td>
    <td>
      <li>Nim standard library</li>
      <li>Available to use `if` statement and `for` statement</li>
      <li>Easy to collaborate with designer or markup enginner</li>
    </td>
    <td>
      <ul>
        <li>Cannot define plural procedures in one file</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>Karax</td>
    <td>
      <li>Available to define plural Procedures in one file</li>
      <li>Available to use `if` statement and `for` statement</li>
    </td>
    <td>
      <ul>
        <li>Maybe difficult to collaborate with designer or markup enginner</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>nim-templates</td>
    <td>
      <ul>
        <li>Available to define plural Procedures in one file</li>
        <li>Available to use `if` statement and `for` statement</li>
        <li>Easy to collaborate with designer or markup enginner</li>
      </ul>
    </td>
    <td>
      <ul>
        <li>Maintained by a person</li>
      </ul>
    </td>
  </tr>
</table>

Views file should be in `app/http/views` dir.

### Block component example

Controller and result is same for each example.

controller
```nim
proc index*(): Response =
  let message = "Basolato"
  return render(indexView(message))
```

result
```html
<html>
  <head>
    <title>Basolato</title>
  </head>
  <body>
    <p>Basolato</p>
  </body>
</html>
```

#### htmlgen

```nim
import htmlgen

proc baseImpl(content:string): string =
  html(
    head(
      title("Basolato")
    ),
    body(content)
  )

proc indexImpl(message:string): string =
  p(message)

proc indexView*(message:string): string =
  baseImpl(indexImpl(message))
```

#### SCF
SCF should divide procs for each file

baseImpl.nim
```nim
#? stdtmpl | standard
#proc baseImpl*(content:string): string =
<html>
  <heade>
    <title>Basolato</title>
  </head>
  <body>
    $content
  </body>
</html>
```

indexImpl.nim
```nim
#? stdtmpl | standard
#proc indexImpl*(message:string): string =
<p>$message</p>
```

index_view.nim
```nim
#? stdtmpl | standard
#import baseImpl
#import indexImpl
#proc indexView*(message:string): string =
${baseImpl(indexImpl(message))}
```

#### Karax
This usage is **Server Side HTML Rendering**

```nim
import karax / [karasdsl, vdom]

proc baseImpl(content:string): string =
  var vnode = buildView(html):
    head:
      title: text("Basolato")
    body: text(content)
  return $vnode

proc indexImpl(message:string): string =
  var vnode = buildView(p):
    text(message)
  return $vnode

proc indexView*(message:string): string =
  baseImpl(indexImpl(message))
```