import os, strutils, strformat

proc jsCompire*() =
  let currentDir = getCurrentDir() / "app/http/views/scripts"
  if dirExists(currentDir):
    createDir(getCurrentDir() / "public/js")
    for f in walkDirRec(currentDir):
      if f.endsWith(".nim"):
        let jsFileName = f.splitFile().name
        let cmd = &"nim js -o:{getCurrentDir()}/public/js/{jsFileName}.js {f}"
        echo cmd
        discard execShellCmd(cmd)
