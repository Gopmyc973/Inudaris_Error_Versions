local Functions = require("games/Inudaris/primitives/main_functions")
local Loader = {}
Loader.__index = Loader

function Loader:finish_loading()
	game:running() 
end

function Loader:drawLoadingScreen(progress, text)
    local windowWidth, windowHeight = love.graphics.getDimensions()

    -- Draw text.
    font = font or love.graphics.newFont(26)

    local textX = math.floor((windowWidth - font:getWidth(text)) / 2)
    local textY = math.floor(windowHeight/2) - font:getHeight()

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(font)
    love.graphics.print(text, textX, textY)

    -- Draw progress bar.
    local progressWidthFull    = 400
    local progressWidthCurrent = progress * progressWidthFull
    local progressHeight       = 20
    local progressX            = math.floor((windowWidth - progressWidthFull) / 2)
    local progressY            = math.floor(windowHeight/2)

    love.graphics.setColor(.2, .2, .2)
    love.graphics.rectangle("fill", progressX, progressY, progressWidthFull, progressHeight)
    love.graphics.setColor(.1, .3, 1)
    love.graphics.rectangle("fill", progressX, progressY, progressWidthCurrent, progressHeight)
end

function Loader:presentLoadingScreen(progress, text)
    love.graphics.clear()
    Loader:drawLoadingScreen(progress, text)
    love.graphics.present()
end
Loader:presentLoadingScreen(0/10, "Loading functions...") ; Functions:load()
Loader:presentLoadingScreen(1/10, "Loading settings...")  ; Functions:settings()
Loader:presentLoadingScreen(2/10, "Loading material...")  ; Functions:load_material()
Loader:presentLoadingScreen(3/10, "Loading player...")  ; Functions:load_player()
Loader:presentLoadingScreen(4/10, "Loading weapons...")  ; Functions:load_weapons()
Loader:presentLoadingScreen(5/10, "Loading enemies...")  ; Functions:load_enemy()
Loader:presentLoadingScreen(6/10, "Loading objects...")  ; Functions:load_object()
Loader:presentLoadingScreen(7/10, "Loading extensions...") ; Functions:extensions()
Loader:presentLoadingScreen(8/10, "Loading world...")  ; Functions:load_world()
Loader:presentLoadingScreen(9/10, "Initialization")  ; game:running()

function Loader:draw()
    Loader:drawLoadingScreen(10/10, "Done loading!") 
end

return Loader
