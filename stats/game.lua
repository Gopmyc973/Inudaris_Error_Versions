local Game = {}
Game.__index = Game

function Game:load()
    local self = setmetatable({}, Game)
    self.state = {menu = true, running = false, dead = false, loading = false, developer = true}
    return self
end

function Game:menu()
    game.state["menu"] = true
    game.state["dead"] = false
    game.state["running"] = false
    game.state["loading"] = false
end

function Game:running()
    game.state["menu"] = false
    game.state["dead"] = false
    game.state["running"] = true
    game.state["loading"] = false
end

function Game:dead()
    game.state["menu"] = false
    game.state["dead"] = true
    game.state["running"] = false
    game.state["loading"] = false
end

function Game:loading()
    game.state["menu"] = false
    game.state["dead"] = false
    game.state["running"] = false
    game.state["loading"] = true
end

function Game:menu()
    game.state["menu"] = true
    game.state["dead"] = false
    game.state["running"] = false
    game.state["loading"] = false
end

function Game:developer()
    if game.state["developer"] then
        game.state["developer"] = false
    else
        game.state["developer"] = true
    end
end

function Game:stats()
    local state
    Verifications = {
        { z = game.state["menu"]},
        { z = game.state["dead"]},
        { z = game.state["running"]},
        { z = game.state["loading"]}
    }
    for i = 1, #Verifications do
        if Verifications[i].z == true then
            state = Verifications[i].z
        end
    end
    return state
end

function Game:stats_print()
    local state_print
    Verifications_print = {
        { z = game.state["menu"], t = "menu"},
        { z = game.state["dead"], t = "dead"},
        { z = game.state["running"], t = "running"},
        { z = game.state["loading"], t = "loading"}
    }
    for i = 1, #Verifications_print do
        if Game:stats() == Verifications_print[i].z then
            state_print = Verifications_print[i].t
        end
    end
    return state_print
end

return Game

