#!/usr/bin/env bats

#wslgsu testing
@test "wslgsu - Help" {
  run out/wslgsu --help
  [ "${lines[0]}" = "wslact - Part of wslu, a collection of utilities for Windows 10 Windows Subsystem for Linux" ]
  [ "${lines[1]}" = "Usage: wslgsu [-u USERNAME] [-n NAME] [-S] SERVICE/COMMAND" ]
  [ "${lines[2]}" = "wslgsu [-hv]" ]
}

@test "wslgsu - Help - Alt." {
  run out/wslgsu -h
  [ "${lines[1]}" = "Usage: wslgsu [-u USERNAME] [-n NAME] [-S] SERVICE/COMMAND" ]
  [ "${lines[2]}" = "wslgsu [-hv]" ]
}