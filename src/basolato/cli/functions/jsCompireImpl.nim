import os, strutils, strformat

proc jsCompire*() =
  let currentDir = getCurrentDir() / "app/http/views/scripts"
  if dirExists(currentDir):
    createDir(getCurrentDir() / "public/js")
    for f in walkDirRec(currentDir):
      var outPath = newSeq[string]()
      var isInScript = false
      for part in f.split("/"):
        if part == "scripts":
          isInScript = true
          continue
        if part.contains(".nim"):
          break
        if isInScript:
          outPath.add(part)
      let outDir = outPath.join("/")
      if f.endsWith(".nim"):
        let jsFileName = f.splitFile().name
        let cmd = &"nim js -o:{getCurrentDir()}/public/js/{outDir}/{jsFileName}.js {f}"
        echo cmd
        discard execShellCmd(cmd)
