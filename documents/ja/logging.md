ログ
===
[戻る](../../README.md)

コンテンツ

<!--ts-->
   * [ログ](#ログ)
      * [イントロダクション](#イントロダクション)
      * [API](#api)
      * [サンプル](#サンプル)

<!-- Added by: root, at: Fri Dec 31 11:51:00 UTC 2021 -->

<!--te-->

## イントロダクション
環境変数`LOG_IS_DISPLAY`に`true`が設定されていれば、`echoLog`関数、`echoErrorMsg`関数を実行した時に、その内容がターミナルに表示されます。`false`が設定されていれば、表示されません。

環境変数`LOG_DIR`はログファイルを出力するディレクトリのパスです。

環境変数`LOG_IS_FILE`に`true`が設定されていれば、`echoLog`関数を実行した時に、その内容がログファイルに出力されます。`false`が設定されていれば、出力されません。

環境変数`LOG_IS_ERROR_FILE`に`true`が設定されていれば、`echoErrorMsg`関数を実行した時に、その内容がエラーログファイルに出力されます。`false`が設定されていれば、出力されません。

## API
```nim
proc echoLog*(output: any, args:varargs[string]) =

proc echoErrorMsg*(msg:string) =
```

## サンプル

```nim
import basolato/logging

proc index*(request:Request, params:Params):Future[Response] {.async.} =
  echoLog("index")
```
