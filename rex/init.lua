-- Prefix passthrough
rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- tmux repeatable bindings (bind -r) as a repeat mode
rex.mode("repeat", { exclusive = true })
rex.bind("ctrl+a>ctrl+r", "client.mode.enter", { name = "repeat" })
rex.bind("repeat/enter", "client.mode.exit")
rex.bind("repeat/escape", "client.mode.exit")
rex.bind("repeat/k", "pane.focus", { direction = "up" })
rex.bind("repeat/j", "pane.focus", { direction = "down" })
rex.bind("repeat/h", "pane.focus", { direction = "left" })
rex.bind("repeat/l", "pane.focus", { direction = "right" })
rex.bind("repeat/ctrl+h", "pane.resize", { direction = "left" })
rex.bind("repeat/ctrl+j", "pane.resize", { direction = "down" })
rex.bind("repeat/ctrl+k", "pane.resize", { direction = "up" })
rex.bind("repeat/ctrl+l", "pane.resize", { direction = "right" })

rex.bind("ctrl+a>c", "client.tab.new")
rex.bind("ctrl+a>p", "client.tab.previous")
rex.bind("ctrl+a>n", "client.tab.next")
rex.bind("ctrl+a>1", "client.tab.goto", { index = 1 })
rex.bind("ctrl+a>2", "client.tab.goto", { index = 2 })
rex.bind("ctrl+a>3", "client.tab.goto", { index = 3 })
rex.bind("ctrl+a>4", "client.tab.goto", { index = 4 })
rex.bind("ctrl+a>5", "client.tab.goto", { index = 5 })
rex.bind("ctrl+a>6", "client.tab.goto", { index = 6 })
rex.bind("ctrl+a>7", "client.tab.goto", { index = 7 })
rex.bind("ctrl+a>8", "client.tab.goto", { index = 8 })
rex.bind("ctrl+a>9", "client.tab.goto", { index = 9 })
rex.bind("ctrl+a>ctrl+h", "pane.resize", { direction = "left" })
rex.bind("ctrl+a>ctrl+j", "pane.resize", { direction = "down" })
rex.bind("ctrl+a>ctrl+k", "pane.resize", { direction = "up" })
rex.bind("ctrl+a>ctrl+l", "pane.resize", { direction = "right" })


rex.bind("ctrl+a>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+a>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+a>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+a>l", "pane.focus", { direction = "right" })
rex.bind("ctrl+a>shift+5", "pane.split", { direction = "right" })
rex.bind("ctrl+a>shift+'", "pane.split", { direction = "down" })
rex.bind("ctrl+a>x", "pane.close")


rex.bind("ctrl+a>s", "session.switch")
rex.bind("ctrl+a>shift+k", "session.close")
rex.bind("ctrl+a>shift+n", "session.new")
rex.bind("ctrl+a>shift+w", "session.rename")
rex.bind("ctrl+a>shift+x", "client.tab.close")


rex.bind("ctrl+a>b", "client.sidebar.toggle")
rex.bind("ctrl+a>r", "client.config.reload")


-- Sessionizer (ported from ./herdr_sessionizer)
-- Pick a project directory, then focus its session or create one there.
local HOME = os.getenv("HOME")
local SESSIONIZER_ROOTS = {
  HOME .. "/workspace/wtg",
  HOME .. "/workspace/wtg/platform.git",
  HOME .. "/workspace/wtg/teleport.git",
  HOME .. "/workspace/private",
  HOME .. "/workspace",
}
local SESSIONIZER_EXTRA = { HOME .. "/.dotfiles" }

local function session_label_for(dir)
  return ((dir:match("([^/]+)/*$") or dir):gsub("%.", "_"))
end

rex.action {
  name  = "sessionizer",
  title = "Sessionizer: Open Project…",
  args  = { dir = "string?" },
  run   = function(ctx, args)
    local dir = args.dir
    if dir == nil then
      local argv = { "find" }
      for _, root in ipairs(SESSIONIZER_ROOTS) do argv[#argv + 1] = root end
      for _, a in ipairs({ "-mindepth", "1", "-maxdepth", "1", "-type", "d" }) do
        argv[#argv + 1] = a
      end
      -- find exits non-zero when a root is missing; keep whatever it found.
      local r = rex.exec(argv, { timeout = 10 })
      local items, seen = {}, {}
      local function add(path)
        if path ~= "" and not seen[path] then
          seen[path] = true
          items[#items + 1] = {
            id = path,
            title = session_label_for(path),
            subtitle = path:sub(1, #HOME) == HOME and "~" .. path:sub(#HOME + 1) or path,
            icon = "folder",
          }
        end
      end
      for _, p in ipairs(SESSIONIZER_EXTRA) do add(p) end
      if r then for line in r.stdout:gmatch("[^\n]+") do add(line) end end

      dir = rex.ui.pick {
        title = "Open project",
        placeholder = "Filter projects",
        items = items,
      }
      if dir == nil then return end
    end

    local label = session_label_for(dir)

    local list, err = rex.call("session.list")
    if list == nil then error("session.list: " .. tostring(err), 0) end
    local session_id
    for _, s in ipairs(list.sessions or list) do
      if s.label == label then
        session_id = s.session_id or s.id
        break
      end
    end

    if session_id == nil then
      local created, cerr = rex.call("session.create", {
        label = label,
        initial_windows = {
          {
            layout = rex.layout.block {
              flavor = "com.superlogical.terminal.shell",
              options = { cwd = dir },
            },
          },
        },
      })
      if created == nil then error("session.create: " .. tostring(cerr), 0) end
      session_id = created.session_id or (created.session and created.session.session_id) or created.id
    end

    rex.client.queue("session.select", { id = session_id })
  end,
}
rex.bind("ctrl+a>f", "sessionizer")
