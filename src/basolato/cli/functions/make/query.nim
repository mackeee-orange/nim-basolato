import os, strformat, terminal, strutils
import utils


proc makeQuery*(target:string, message:var string):int =
  let targetName = target.split("/")[^1]
  let targetCaptalized = snakeToCamel(targetName)
  let targetProcCaptalized = snakeToCamelProcName(targetName)
  let relativeToDatabasePath = "../".repeat(target.split("/").len) & &"../../../../"
  let relativeToInterfacePath = "../".repeat(target.split("/").len) & &"../../"

  let QUERY_INTERFACE = &"""
import asyncdispatch


type I{targetCaptalized}Query* = tuple
"""

  let QUERY_SERVICE = &"""
import interface_implements
import allographer/query_builder
from {relativeToDatabasePath}config/database import rdb
import {relativeToInterfacePath}usecases/{target}/{targetName}_query_interface


type {targetCaptalized}Query* = ref object

proc new*(typ:type {targetCaptalized}Query):{targetCaptalized}Query =
  return {targetCaptalized}Query()

implements {targetCaptalized}Query, I{targetCaptalized}Query:
  discard
"""

  let INTERFACE_PATH = &"{getCurrentDir()}/app/data_stores/query_services/{target}/{targetName}_query_interface.nim"
  let IMPL_PATH = &"{getCurrentDir()}/app/data_stores/query_services/{target}/{targetName}_query.nim"

  # check dir and file is not exists
  if isDirExists(INTERFACE_PATH):
    return 1
  if isDirExists(IMPL_PATH):
    return 1

  # query service interface
  var targetPath = INTERFACE_PATH
  if isFileExists(targetPath): return 1
  createDir(parentDir(targetPath))
  var f = open(targetPath, fmWrite)
  defer: f.close()
  f.write(QUERY_INTERFACE)
  message = &"Created query interface in {targetPath}"
  styledWriteLine(stdout, fgGreen, bgDefault, message, resetStyle)

  # query
  targetPath = IMPL_PATH
  if isFileExists(targetPath): return 1
  createDir(parentDir(targetPath))
  f = open(targetPath, fmWrite)
  f.write(QUERY_SERVICE)
  message = &"Created query in {targetPath}"
  styledWriteLine(stdout, fgGreen, bgDefault, message, resetStyle)

  # update di_container.nim
  targetPath = &"{getCurrentDir()}/app/di_container.nim"
  f = open(targetPath, fmRead)
  var textArr = f.readAll().splitLines()
  # get offset where column is empty string
  var importOffset:int
  for i, row in textArr:
    if row == "type DiContainer* = tuple":
      importOffset = i
      break
  if importOffset < 1:
    textArr.insert("", 0)
    importOffset = 1
  # insert import
  textArr.insert(&"import data_stores/query_services/{target}/{targetName}_query", importOffset-1)
  textArr.insert(&"import usecases/{target}/{targetName}_query_interface", importOffset-1)
  textArr.insert(&"# {targetName}", importOffset-1)
  # insert di difinition
  var isAfterDiDifinision:bool
  var importDifinisionOffset:int
  for i, row in textArr:
    if row == "type DiContainer* = tuple":
      isAfterDiDifinision = true
    if isAfterDiDifinision and row == "":
      importDifinisionOffset = i
      break
  textArr.insert(&"  {targetProcCaptalized}Query: I{targetCaptalized}Query", importDifinisionOffset)
  # insert constructor
  textArr.insert(&"    {targetProcCaptalized}Query: {targetCaptalized}Query.new().toInterface(),", textArr.len-4)
  # write in file
  f = open(targetPath, fmWrite)
  for i in 0..textArr.len-2:
    f.writeLine(textArr[i])
  message = &"Updated {targetPath}"
  styledWriteLine(stdout, fgGreen, bgDefault, message, resetStyle)

  return 0
