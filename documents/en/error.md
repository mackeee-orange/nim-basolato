Error
===
[back](../../README.md)

Table of Contents

<!--ts-->
   * [Error](#error)
      * [Introduction](#introduction)
      * [Raise Error and Redirect](#raise-error-and-redirect)
      * [How to display custom error page](#how-to-display-custom-error-page)

<!-- Added by: root, at: Fri Dec 31 11:49:11 UTC 2021 -->

<!--te-->

## Introduction
When exception raised, Basolato will catch excepton and return Exception status response.  

```nim
raise newException(Error403, "session timeout")
```
It return `403 response` and 'session timeout' will be in response body.

Basolato have all response status exception type from `300` to `505`  
[List of HTTP Status](https://nim-lang.org/docs/httpcore.html#10)


## Raise Error and Redirect
If you want to redirect when error raised, you can use `errorRedirect` proc.  
This proc is able to used only in `controller`.

```nim
return errorRedirect("/login")
```

In out of controller, raise `ErrorRedirect` error.
```nim
raise newException(ErrorRedirect, "/login")
```

## How to display custom error page
Basolato has its own error page. However if you put your original error page in dir `app/http/views/errors/{http code}.html`, these are returned with priority.  
If http status code html file is not found and `error.html` exists, `error.html` is returned.

・priority  
{http code}.html > error.html > Basolato own error page

This function is avaiable only in `release` enviroment　(When you compile with option `-d:release`).
In develop enviroment (compile **without** `-d:release`), framerwork's error page is always returned.

```
── views
    └── errors
         ├── 400.html
         ├── 404.html
         └── error.html
```
