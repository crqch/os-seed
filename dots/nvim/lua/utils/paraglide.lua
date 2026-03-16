local M = {}

-- Plugin State
M.current_locale = "en"
M.replace_newlines = false
M.last_format = "{m.%s()}" -- Default to JSX/Svelte standard

local CACHE_FILE = vim.fn.stdpath "data" .. "/paraglide_cache.json"

-----------------------------------------------------------
-- PERSISTENCE LOGIC
-----------------------------------------------------------
local function load_state()
  local cwd = vim.fn.getcwd()
  local file = io.open(CACHE_FILE, "r")
  if file then
    local content = file:read "*a"
    file:close()

    local ok, data = pcall(vim.fn.json_decode, content)
    if ok and type(data) == "table" and data[cwd] then
      M.current_locale = data[cwd].locale or "en"
      if data[cwd].replace_newlines ~= nil then
        M.replace_newlines = data[cwd].replace_newlines
      end
      if data[cwd].last_format ~= nil then
        M.last_format = data[cwd].last_format
      end
    end
  end
end

local function save_state()
  local cwd = vim.fn.getcwd()
  local existing_data = {}

  local file = io.open(CACHE_FILE, "r")
  if file then
    local content = file:read "*a"
    file:close()
    local ok, data = pcall(vim.fn.json_decode, content)
    if ok and type(data) == "table" then
      existing_data = data
    end
  end

  existing_data[cwd] = {
    locale = M.current_locale,
    replace_newlines = M.replace_newlines,
    last_format = M.last_format,
  }

  local out_file = io.open(CACHE_FILE, "w")
  if out_file then
    out_file:write(vim.fn.json_encode(existing_data))
    out_file:close()
  end
end

load_state()

-----------------------------------------------------------
-- HELPER
-----------------------------------------------------------
local function find_locale_file(lang)
  local matches = vim.fs.find("messages", {
    limit = math.huge,
    type = "directory",
    path = vim.fn.getcwd(),
  })

  for _, dir in ipairs(matches) do
    local expected_path = dir .. "/" .. lang .. ".json"
    if vim.fn.filereadable(expected_path) == 1 then
      return expected_path
    end
  end
  return nil
end

-----------------------------------------------------------
-- EXPOSED COMMANDS
-----------------------------------------------------------
function M.toggle_newline_replacement()
  M.replace_newlines = not M.replace_newlines
  save_state()
  local state = M.replace_newlines and "ON" or "OFF"
  vim.notify("Paraglide: Newline replacement is " .. state, vim.log.levels.INFO)
end

function M.set_locale()
  vim.ui.input({ prompt = "Set Paraglide Locale: ", default = M.current_locale }, function(input)
    if input and input ~= "" then
      M.current_locale = input
      save_state()
      vim.notify("Paraglide: Target locale set to '" .. input .. "'", vim.log.levels.INFO)
    end
  end)
end

function M.extract()
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)

  vim.schedule(function()
    local s_start = vim.fn.getpos "'<"
    local s_end = vim.fn.getpos "'>"

    local row1, col1 = s_start[2] - 1, s_start[3] - 1
    local row2, col2 = s_end[2] - 1, s_end[3]

    if vim.fn.visualmode() == "V" then
      col1 = 0
      col2 = #vim.fn.getline(s_end[2])
    end

    local lines = vim.api.nvim_buf_get_text(0, row1, col1, row2, col2, {})
    local selected_text = table.concat(lines, "\n")

    if M.replace_newlines then
      selected_text = selected_text:gsub("\n", " ")
      selected_text = selected_text:gsub("%s+", " ")
    end

    local adjs = {
      "away",
      "antsy",
      "brave",
      "calm",
      "dizzy",
      "eager",
      "fancy",
      "glad",
      "happy",
      "jolly",
      "clever",
      "wild",
      "shy",
      "loud",
      "cool",
    }
    local nouns = {
      "tadpole",
      "apple",
      "bear",
      "cat",
      "dog",
      "eagle",
      "frog",
      "goat",
      "horse",
      "iguana",
      "lion",
      "mouse",
      "owl",
      "tiger",
    }
    local verbs =
      { "fold", "jump", "run", "skip", "walk", "fly", "swim", "crawl", "climb", "dive", "spin", "roll", "hide", "seek" }

    math.randomseed(os.time() + vim.loop.now())
    local random_id = string.format(
      "%s_%s_%s_%s",
      adjs[math.random(#adjs)],
      adjs[math.random(#adjs)],
      nouns[math.random(#nouns)],
      verbs[math.random(#verbs)]
    )

    -- 1. STRICT STATIC ORDER
    local raw_templates = { "{m.%s()}", "m.%s()", "{@html m.%s()}" }

    -- Figure out which index corresponds to our last saved format
    local default_idx = 1
    for i, t in ipairs(raw_templates) do
      if t == M.last_format then
        default_idx = i
        break
      end
    end

    -- Cleaner, explicitly numbered prompt
    local prompt_text =
      string.format("Format [ 1: {m.id()} | 2: m.id() | 3: {@html m.id()} ] (Enter for %d): ", default_idx)

    vim.ui.input({ prompt = prompt_text }, function(input)
      if input == nil then
        return
      end -- User pressed Esc

      -- 2. Handle empty Enter press vs explicit number
      local idx
      if input == "" then
        idx = default_idx
      else
        idx = tonumber(input)
      end

      -- Safety check in case you mash a letter or wrong number
      if not idx or not raw_templates[idx] then
        vim.notify("Paraglide: Invalid format choice.", vim.log.levels.ERROR)
        return
      end

      -- Save the selected raw template for next time
      M.last_format = raw_templates[idx]
      save_state()

      local choice = string.format(raw_templates[idx], random_id)

      local filepath = find_locale_file(M.current_locale)
      if not filepath then
        vim.notify("No " .. M.current_locale .. ".json found in any messages/ dir!", vim.log.levels.ERROR)
        return
      end

      -- 1. Replace text in Neovim buffer
      vim.api.nvim_buf_set_text(0, row1, col1, row2, col2, { choice })

      -- 2. Read existing JSON purely as a string to preserve order/emojis
      local file = io.open(filepath, "r")
      local content = "{}"
      if file then
        content = file:read "*a" or "{}"
        file:close()
      end

      -- Strip trailing whitespace
      content = content:match "^(.-)%s*$"
      if content == "" then
        content = "{}"
      end

      -- Encode ONLY the value to handle inner quotes/newlines safely
      local safe_value = vim.fn.json_encode(selected_text)
      local new_entry = string.format('\n  "%s": %s\n}', random_id, safe_value)

      if content == "{}" then
        content = "{" .. new_entry
      elseif content:sub(-1) == "}" then
        content = content:sub(1, -2) .. "," .. new_entry
      else
        vim.notify("Paraglide: Malformed JSON end. Aborting to prevent corruption.", vim.log.levels.ERROR)
        return
      end

      local out_file = io.open(filepath, "w")
      if out_file then
        out_file:write(content)
        out_file:close()

        -- 3. Run Prettier silently in the background
        vim.system({ "prettier", "--write", filepath }, { text = true }, function()
          vim.schedule(function()
            vim.notify("Added " .. random_id, vim.log.levels.INFO)

            local has_watson, watson = pcall(require, "lazy-watson")
            if has_watson and type(watson.setup) == "function" then
              pcall(watson.setup)
            end
          end)
        end)
      else
        vim.notify("Failed to write to: " .. filepath, vim.log.levels.ERROR)
      end
    end)
  end)
end

return M
