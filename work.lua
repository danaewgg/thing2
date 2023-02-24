if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- [[ Variables ]]

local clock = os.clock

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")

local FrameRateManager = Stats:WaitForChild("FrameRateManager")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local GameUI = PlayerGui:WaitForChild("GameUI")
local Boosts = GameUI:FindFirstChild("Main").Boosts
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local ClientAction = GameEvents:WaitForChild("ClientAction")
local Character

local renderAverage
local frameTime_variance
local data_ping
local data_split
local ping
local ping_variance

if not getgenv().releasingEnabled then
    getgenv().releasingEnabled = true
end

local quickShotTimings = {
    [1] = 0.03, -- Bronze
    [2] = 0.06, -- Silver 
    [3] = 0.07, -- Gold
    [4] = 0.09, -- Diamond
}

local TextBoxes = {} -- For referencing timings later on (:Set)

local Timings = { -- 35 shot types in total
    ["Standing Shot"] 			 = {
        [1] = 0, -- 30 ping
        [2] = 0.584, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.545, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping
    },
    ["Off Dribble Shot"] 		 = {
        [1] = 0, -- 30 ping
        [2] = 0.6352, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.595, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping  
    },
    ["Drift Shot"] 				 = {
        [1] = 0, -- 30 ping
        [2] = 0.617, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.579, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Far Shot"] 				 = {
        [1] = 0, -- 30 ping
        [2] = 0.3605, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.325, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    Freethrow 				     = {
        [1] = 0, -- 30 ping
        [2] = 0, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Hopstep Off Dribble Shot"] = {
        [1] = 0, -- 30 ping
        [2] = 0.6, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.556, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Hopstep Drift Shot"] 		 = {
        [1] = 0, -- 30 ping
        [2] = 0.584, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.5441, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    Layup 				 	     = {
        [1] = 0, -- 30 ping
        [2] = 0.4715, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.442, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Reverse Layup"] 			 = {
        [1] = 0, -- 30 ping
        [2] = 0.4835, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.445, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Hopstep Layup"] 			 = {
        [1] = 0, -- 30 ping
        [2] = 0.451, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.41, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Eurostep Layup"] 			 = {
        [1] = 0, -- 30 ping
        [2] = 0.4338, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.39, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Dropstep Layup"] 			 = {
        [1] = 0, -- 30 ping
        [2] = 0.48, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.445, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Post Layup"] 			  	 = {
        [1] = 0, -- 30 ping
        [2] = 0.468, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.43, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    Floater    				     = {
        [1] = 0, -- 30 ping
        [2] = 0.4831, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.445, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Hopstep Floater"] 		 = {
        [1] = 0, -- 30 ping
        [2] = 0.4295, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.395, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Eurostep Floater"] 		 = {
        [1] = 0, -- 30 ping
        [2] = 0.4338, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.39, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Close Shot"] 				 = {
        [1] = 0, -- 30 ping
        [2] = 0.448, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.41, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Hopstep Close Shot"] 		 = {
        [1] = 0, -- 30 ping
        [2] = 0.418, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.3785, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Dropstep Close Shot"] 	 = {
        [1] = 0, -- 30 ping
        [2] = 0.416, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.38, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Post Close Shot"] 		 = {
        [1] = 0, -- 30 ping
        [2] = 0.4515, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.41, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["AlleyOop Close Shot"] 	 = {
        [1] = 0, -- 30 ping
        [2] = 0, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Standing Dunk"] 		 	 = {
        [1] = 0, -- 30 ping
        [2] = 0.52, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.47, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Hopstep Standing Dunk"] 	 = {
        [1] = 0, -- 30 ping
        [2] = 0.46, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.42, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Dropstep Standing Dunk"]   = {
        [1] = 0, -- 30 ping
        [2] = 0.465, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.43, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Post Standing Dunk"] 		 = {
        [1] = 0, -- 30 ping
        [2] = 0.50, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.475, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Driving Dunk"] 			 = {
        [1] = 0, -- 30 ping
        [2] = 0.5151, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.475, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["AlleyOop Standing Dunk"] 	 = {
        [1] = 0, -- 30 ping
        [2] = 0, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["AlleyOop Driving Dunk"] 	 = {
        [1] = 0, -- 30 ping
        [2] = 0, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Post Fade"] 				 = {
        [1] = 0, -- 30 ping
        [2] = 0.6115, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.565, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Drift Post Fade"] 		 = {
        [1] = 0, -- 30 ping
        [2] = 0.616, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.578, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Hopstep Post Fade"] 		 = {
        [1] = 0, -- 30 ping
        [2] = 0.583, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.5415, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Dropstep Post Fade"] 		 = {
        [1] = 0, -- 30 ping
        [2] = 0.58, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.546, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Post Hook"] 				 = {
        [1] = 0, -- 30 ping
        [2] = 0.467, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.42, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Hopstep Post Hook"] 		 = {
        [1] = 0, -- 30 ping
        [2] = 0.435, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.395, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    },
    ["Dropstep Post Hook"] 		 = {
        [1] = 0, -- 30 ping
        [2] = 0.4345, -- 40 ping
        [3] = 0, -- 50 ping
        [4] = 0, -- 60 ping
        [5] = 0, -- 70 ping
        [6] = 0.40, -- 80 ping
        [7] = 0, -- 90 ping
        [8] = 0, -- 100 ping 
    }
}

function linearRegression(data)
    -- Compute the mean of the independent and dependent variables
    local meanX = 0
    local meanY = 0
    local count = 0

    for _, point in ipairs(data) do
        if point[2] ~= 0 then  -- Only include points where the timing is not zero
            meanX = meanX + point[1]
            meanY = meanY + point[2]
            count = count + 1
        end
    end
    meanX = meanX / count
    meanY = meanY / count

    -- Compute the variance and covariance of the independent and dependent variables
    local varX = 0
    local varY = 0
    local covXY = 0

    for _, point in ipairs(data) do
        if point[2] ~= 0 then  -- Only include points where the timing is not zero
            local x = point[1]
            local y = point[2]
            varX = varX + (x - meanX)^2
            varY = varY + (y - meanY)^2
            covXY = covXY + (x - meanX) * (y - meanY)
        end
    end

    -- Estimate the slope and intercept of the regression line
    local slope = covXY / varX
    local intercept = meanY - slope * meanX

    -- Return the estimated model parameters
    return slope, intercept
end

function calculateShotTiming(shotType, ping)
    print("Called shot")
    -- Extract the timing values for the given shottype
    local timingValues = Timings[shotType]

    -- Define the data points for the linear regression model
    local data = {
        [1] = {
            [1] = 30, -- ping
            [2] = timingValues[1] -- index
        },
        [2] = {
            [1] = 40, -- ping
            [2] = timingValues[2] -- index
        },
        [3] = {
            [1] = 50, -- ping
            [2] = timingValues[3] -- index
        },
        [4] = {
            [1] = 60, -- ping
            [2] = timingValues[4] -- index
        },
        [5] = {
            [1] = 70, -- ping
            [2] = timingValues[5] -- index
        },
        [6] = {
            [1] = 80, -- ping
            [2] = timingValues[6] -- index
        },
        [7] = {
            [1] = 90, -- ping
            [2] = timingValues[7] -- index
        },
        [8] = {
            [1] = 100, -- ping
            [2] = timingValues[8] -- index
        },
    }

    -- Estimate the model parameters for the linear regression model
    local slope, intercept = linearRegression(data)

    -- Use the model to compute the predicted timing value for the given ping value
    local timing = intercept + slope * ping

    local hasStreak = Character:GetAttribute("Streak")
    if hasStreak then
        local streakMeter = Character:GetAttribute("StreakMeter")
        local streakType = Character:GetAttribute("StreakType")

        if shotType == "Standing Shot" or shotType == "Off Dribble Shot" or shotType == "Hopstep Off Dribble Shot" then
            if streakMeter > 0 and streakType == "Spot-Up Shooter" then
                timing = timing - 0.05 -- Spot-Up timing
            elseif streakMeter < 0 then
                timing = timing + 0.03 -- Cold timing
            end
        end
    end

    local isQuickShot = Boosts:FindFirstChild("Quick Shot")
    if isQuickShot and isQuickShot:GetAttribute("Activated") then
        local quickShotTier = Character.Boosts["Quick Shot"].Value
        timing = timing - quickShotTimings[quickShotTier]
    end

    -- Return the predicted timing value
    return timing
end

function autoRelease(shotType)
    if not getgenv().releasingEnabled then
        return
    end

    if not shotType then
        shotType = Character:GetAttribute("ShotType")
        
        if shotType == nil then
            return
        end
    end
    
    if not Timings[shotType] then
        return
    end
    
    local startTime = os.clock()
    local function Shoot()
        print(calculateShotTiming(shotType, ping))
        if (os.clock() - startTime) >= calculateShotTiming(shotType, ping) then
            ClientAction:FireServer("Shoot", false)
            warn(string.format("Time taken: %.3f", os.clock() - startTime))
            RunService:UnbindFromRenderStep("Auto-Release")
        end
    end
    
    RunService:BindToRenderStep("Auto-Release", 0, Shoot)
end

local function onOverrideMouseIconBehavior()
    UserInputService.OverrideMouseIconBehavior = 1 -- ForceShow
end

local function onCharacterAdded(character)
    Character = character or LocalPlayer.Character
    
    Character:GetAttributeChangedSignal("LandedShotMeter"):Connect(function()
        local landedShotMeter = Character:GetAttribute("LandedShotMeter")
        
        if landedShotMeter ~= nil then
            displayShotResults(landedShotMeter)
        end
    end)
    
    Character:GetAttributeChangedSignal("ShotType"):Connect(function()
        local shotType = Character:GetAttribute("ShotType")

        if shotType ~= nil then
            autoRelease(shotType)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if LocalPlayer.Character then
    onCharacterAdded()
end

task.defer(function()
    while task.wait() do
        data_ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
        data_split = string.split(data_ping, " ")
        
        ping = tonumber(data_split[1])
        ping_variance = tonumber(string.match(data_split[2], "%d+"))

        --print(string.format("FPS: %.2f   Variation: %.2f%%", fps, fps_variation))
        --warn(string.format("PING: %.2f  Variation: %.2f%%", ping, ping_variance))
    end
end)

print("Loaded")
