# AGENTS.md

## Factorio Reference

- Factorio API docs root: <https://lua-api.factorio.com/latest/index.html>
- Runtime API docs: <https://lua-api.factorio.com/latest/index-runtime.html>
- Auxiliary docs: <https://lua-api.factorio.com/latest/index-auxiliary.html>
- Libraries/functions added or modified by Factorio: <https://lua-api.factorio.com/latest/auxiliary/libraries.html>
- Storage rules: <https://lua-api.factorio.com/latest/auxiliary/storage.html>
- Custom command data: <https://lua-api.factorio.com/latest/concepts/CustomCommandData.html>
- Command registration: <https://lua-api.factorio.com/latest/classes/LuaCommandProcessor.html>
- LuaControl teleport: <https://lua-api.factorio.com/latest/classes/LuaControl.html>
- LuaSurface find_non_colliding_position: <https://lua-api.factorio.com/latest/classes/LuaSurface.html>
- LuaCustomTable behavior: <https://lua-api.factorio.com/latest/classes/LuaCustomTable.html>

## Lua Version

- Factorio mods run on a modified Lua 5.2 environment:
  <https://lua-api.factorio.com/latest/index.html>
- Standard Lua 5.2 reference manual:
  <https://www.lua.org/manual/5.2/>
- Local parser tooling available in this repo environment:
  - `lua5.2`
  - `luac5.2`
- These tools are useful for basic Lua 5.2 syntax checks only.
- They do not validate Factorio-specific globals, runtime APIs, event payloads, `storage` behavior, or mod loading semantics.
- Example syntax check:
  - `for f in *.lua; do luac5.2 -p "$f"; done`

## Practical Limitations

- `CustomCommandData.player_index` is optional and is `nil` for server console/RCON commands. Command handlers must not assume a `LuaPlayer` caller exists.
- Factorio modifies parts of the Lua environment for determinism, notably `pairs()` and `math.random()`. Prefer simple, deterministic control flow.
- `LuaCustomTable` is not a normal Lua table:
  - iterate it with `pairs()`, not `ipairs()`
  - do not store it in `storage`
- `storage` has persistence restrictions:
  - no functions
  - no arbitrary metatable assumptions
  - do not write to `storage` during `on_load`
- `require()` has Factorio-specific restrictions. See the libraries/functions doc before assuming stock Lua behavior.
- Stay conservative with language features:
  - write plain Lua 5.2-compatible code
  - avoid relying on Lua 5.3+ features
  - avoid advanced metaprogramming unless Factorio docs explicitly support the pattern

## Repo Guidance

- For command handlers, resolve the caller defensively and support console/RCON only when semantics are clear without a player body or position.
- When a command is player-only, reject console explicitly with a clear message instead of silently no-oping.
- Do not treat every nil/index crash as a bug. Some impossible-state paths are intentionally fail-fast so server operators see corrupted state, broken setup, or invalid invariants instead of silently continuing.
- Prefer official Factorio docs over forum posts, blogs, or stale wiki advice when changing runtime behavior.
