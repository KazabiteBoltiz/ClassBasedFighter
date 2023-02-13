local RepS = game.ReplicatedStorage
local Packages = RepS.Packages
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)

local StateMachine = {}

function StateMachine.Create(scriptInst, mod, defaultState)

    mod.StateTrove = Trove.new()
    mod.StateChanged = Signal.new()
    mod.States = {}
    mod.State = nil

    for _, stateScript in ipairs(scriptInst:GetChildren()) do
        if stateScript:IsA('ModuleScript') then  
            local newState = require(stateScript)
            mod.States[stateScript.Name] = newState
            newState.__index = newState
            newState.Name = stateScript.Name
        end
    end

    function mod:ChangeState(newState)
        if mod.State then
            mod.State:End() 
        end
        mod.StateTrove:Clean()
        mod.StateChanged:Fire(newState)
        mod.State = mod.States[newState].new(mod)
        mod.State:Start()
    end

    function mod:AddState(stateMod)
        if mod.States[stateMod.Name] then return end
        mod.States[stateMod.Name] = require(stateMod)
    end

    function mod:RemoveState(stateMod)
        if not mod.States[stateMod.Name] then return end
        if stateMod.Name == mod.State.Name then
            mod:ChangeState(defaultState)
        end
        mod.States[stateMod.Name] = require(stateMod)
    end

    mod:ChangeState(defaultState)
end

return StateMachine