




--------------------------------------------------------------
----------------------  Load Libraries  ----------------------
local awful = require("awful")

--------------------------------------------------------------
--------------------  tags_utils module  ---------------------
local tag_utils = {}

local function add_tag()
    awful.tag.add(" NewTag ", {
        screen = awful.screen.focused(),
        layout = awful.layout.suit.tile,
        volatile = true
    }):view_only()
end 

local function delete_tag()
    local t = awful.screen.focused().selected_tag
    if not t then return end
    t:delete()
end

local function rename_tag()
    awful.prompt.run {
        prompt       = "New tag name: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end

            local t = awful.screen.focused().selected_tag
            if t then
                t.name = new_name
            end
        end
    }
end

local function move_to_new_tag()
    local c = client.focus
    if not c then return end

    local t = awful.tag.add(c.class,{screen= c.screen, layout = awful.layout.suit.tile, volatile = true })
    c:tags({t})
    t:view_only()
end

-- Busca tags pelo nome BASE (ignorando o índice entre parênteses)
local function find_tag_by_base_name(screen, base_name)
    local pattern = "^" .. base_name .. " %(%d+%)$" -- Padrão: "nome (número)"
    for _, tag in ipairs(screen.tags) do
        if tag.name:match(pattern) then
            return tag
        end
    end
    return nil
end

-- Cria tags com nomeação dinâmica "nome (índice)"
local function create_volatile_tag(c, base_name, screen_index, layout)
    local screen = screen[screen_index]
    if not screen then return end

    -- Tenta encontrar uma tag existente com o nome base
    local existing_tag = find_tag_by_base_name(screen, base_name)
    
    if existing_tag then
        c:move_to_tag(existing_tag)
        existing_tag:view_only()
    else
        -- Cria uma nova tag com nome temporário
        local new_tag = awful.tag.add(base_name, {
            screen = screen,
            layout = layout,
            volatile = true,
        })
        
        -- Atualiza o nome com o índice real da tag
        new_tag.name = base_name .. " (" .. new_tag.index .. ") "
        
        c:move_to_tag(new_tag)
        new_tag:view_only()
    end
end


--------------------------------------------------------------
--------------------  Exported Functions  --------------------
tag_utils.add_tag = add_tag
tag_utils.delete_tag = delete_tag
tag_utils.rename_tag = rename_tag
tag_utils.move_to_new_tag = move_to_new_tag
tag_utils.find_tag_by_base_name = find_tag_by_base_name
tag_utils.create_volatile_tag = create_volatile_tag

return tag_utils