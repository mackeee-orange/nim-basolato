# Package
version       = "0.1.0"
author        = "Anonymous"
description   = "A new awesome basolato package"
license       = "MIT"
srcDir        = "."
bin           = @["main"]
backend       = "c"
# Dependencies
requires "nim >= 1.4.4"
requires "https://github.com/itsumura-h/nim-basolato >= 0.10.0"
requires "allographer >= 0.19.0"
requires "interface_implements >= 0.2.1"
requires "templates >= 0.5"
requires "bcrypt >= 0.2.1"
requires "cligen >= 1.5.9"
requires "dotenv >= 1.1.1"
requires "faker >= 0.14.0"
requires "flatdb >= 0.2.5"
requires "nimAES >= 0.1.2"
requires "redis >= 0.3.0"
requires "sass >= 0.1.0"
requires "ws >= 0.4.4"

task test, "run testament":
  echo staticExec("testament p \"./tests/test_*.nim\"")
  discard staticExec("find tests/ -type f ! -name \"*.*\" -delete 2> /dev/null")
