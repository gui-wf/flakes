{
  writeShellScriptBin,
  bun,
}:

writeShellScriptBin "ccusage" ''
  exec ${bun}/bin/bunx ccusage@latest "$@"
''
