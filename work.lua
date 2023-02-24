if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- [[ Variables ]]

local clock = os.clock

local signature = "[Timings Demo]" -- For easier finding of stuff printed in the dev console
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Terrain = game:GetService("Terrain")
local VirtualUser = game:GetService("VirtualUser")
local NetworkSettings = settings():GetService("NetworkSettings")
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
    getgenv().releasingEnabled = false
end

if not (getgenv().boostFPS or getgenv().parts) then
    getgenv().boostFPS = false
    getgenv().parts = {}
end

getgenv().quickShotTimings = {
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

-- [[ Library ]]

local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()

local GUI = Mercury:Create{
    Name = "Home",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Dark,
    Link = "danhub.lua"
}

local tab_Main = GUI:Tab{
	Name = "Main",
	Icon = "rbxassetid://6034996695"
}

tab_Main:Toggle{
    	Name = "Auto-Release",
	StartingState = getgenv().releasingEnabled,
	Description = "Automatically stop shooting when the shot timing's threshold has been reached",
	Callback = function(state)
	    getgenv().releasingEnabled = state
    end
}

tab_Main:Toggle{
	Name = "FPS Boost",
	StartingState = getgenv().boostFPS,
	Description = "Increase performance by hiding unnecessary parts",
	Callback = function(state)
	    if state ~= false then
	        getgenv().boostFPS = state
            local objects = {workspace, Terrain}
            local gym = workspace:FindFirstChild("Gym")
            local court = workspace:FindFirstChild("Court")
            local arena = workspace:FindFirstChild("Arena")
            local plaza = workspace:FindFirstChild("Plaza")
            local courts = workspace:FindFirstChild("Courts")
            local park = workspace:FindFirstChild("Park")
            local building = workspace:FindFirstChild("Building")

            if gym then
                table.insert(objects, gym)
                table.insert(objects, gym:FindFirstChild("Building"))
            end
            if court then
                table.insert(objects, court)
            end 
            if arena then
                table.insert(objects, arena)
            end
            if plaza then
                table.insert(objects, plaza)
            end
            if courts then
                table.insert(objects, courts)
            end
            if park then
                table.insert(objects, park)
            end
            if building then
                table.insert(objects, building)
            end

            local function isRemoveable(object)
                if object.Name:find("Ball Racks") or object.Name:find("NameUIFolder") or object.Name:find("SpawnLocation") or object.Name:find("Fake Plaza") or object.Name:find("LeaderboardUI") then
                    return true
                end
                if object.Name:find("Timer") or object.Name:find("Slide") or object.Name:find("Net") or object.Name:find("Pole") or object.Name:find("Box") or object.Name:find("RBW") or object.Name:find("Bolts") or object.Name:find("Stand") then -- or object.Name == "Lights"
                    return true
                end
                if object.Name:find("Clouds") then
                    return true
                end
                if gym then
                    if object.Parent == gym then
                        if not object.Name:find("Building") then
                            return true
                        end
                    elseif object.Parent == gym:FindFirstChild("Building") then
                        if not object.Name:find("Light") then
                            return true
                        end
                    end
                end
                if court then
                    if object.Parent == court then
                        if object.Name:find("Baseline") then
                            return true
                        end
                    end
                end
                if arena then
                    if object.Parent == arena then
                        return true
                    end
                end
                if plaza then
                    if object.Parent == plaza then
                        if not object.Name:find("Walls") and not object.Name:find("Path") and not object.Name:find("Floor Directions") and not object.Name:find("Store Doors") and not object.Name:find("Receptionists") and not object.Name:find("Inside") and not object.Name:find("Concrete") and not object.Name:find("Misc.") and not object.Name:find("Court.1") and not object.Name:find("Plaza Lights") then
                            return true
                        end
                    end
                end
                if courts then
                    if object.Parent == courts then
                        --
                    end
                end
                if park then
                    if object.Parent == park then
                        if not object.Name:find("Path Walls") and not object.Name == "Lights" and not object.Name:find("Borders") and not object.Name:find("Trash Cans") and not object.Name:find("Fences") and not object.Name:find("Ground") and not object.Name:find("Benches") then
                            return true
                        end 
                    end
                end
                if building then
                    if object.Name:find("Truss") or object.Name:find("Short Poles") or object.Name:find("SpawnLocation") or object.Name:find("Outlets") or object.Name:find("Switches") or object.Name:find("Trash Bin") or object.Name:find("Vents") or object.Name:find("Screen") or object.Name:find("Baseplate") or object.Name:find("Scoreboard") or object.Name:find("Fire Alarms") or object.Name:find("Electric Box") or object.Name:find("Badge Shelf") or object.Name:find("Exit Signs") or object.Name:find("Mat") or object.Name:find("Trash Can") then
                        return true
                    end
                end

                return false
            end
                
            local function remove(object)
                if isRemoveable(object) then
                    getgenv().parts[object] = object.Parent
                    object.Parent = nil
                end
            end

            for _, object in next, objects do
                for _, child in next, object:GetChildren() do
                    if child.Name:find("_Hoop") then
                        for _, descendant in next, child:GetDescendants() do
                            remove(descendant)
                        end
                    elseif child.Name:find("Court.") then
                        for _, descendant in next, child:GetDescendants() do
                            remove(descendant)
                        end
                    else
                        remove(child)
                    end
                end
            end
	    else
	        getgenv().boostFPS = state
	        
	        for part, parent in next, getgenv().parts do
	            part.Parent = parent
	            getgenv().parts[part] = nil
	        end
	    end
    end
}

-- [[ Functions ]]

function print(...)
    return getgenv().print(signature, ...)
end

function warn(...)
    return getgenv().warn(signature, ...)
end

function prompt(title, text, buttons)
    GUI:Prompt{
        Followup = false, -- idk what this is tbh
        Title = title or "Prompt",
        Text = text or "",
        Buttons = buttons or {
            hi = function()
                print("You ")
            end,
            no = function()
                result = false
            end
        }
    }
end

function notify(heading, description, duration)
    GUI:Notification{
    	Title = heading or "",
    	Text = description or "",
    	Duration = duration or 3
    }
end

function displayShotResults(landedShotMeter)
    local shotType = Character:GetAttribute("ShotType")
    landedShotMeter = landedShotMeter or Character:GetAttribute("LandedShotMeter")
    local currentPing = math.round(Stats.PerformanceStats.Ping:GetValue())
    
    notify("Shot Results", string.format("ShotType: %s \nLandedShotMeter: %.3f \nPing: %s", shotType, landedShotMeter, currentPing))
end

-- Returns the coefficients for a cubic spline interpolant
function splineInterpolant(data)
    local n = #data
    local h = {}
    local alpha = {}
    local l = {}
    local mu = {}
    local z = {}
    local c = {}
    local b = {}
    local d = {}

    for i = 1, n - 1 do
        h[i] = data[i+1][1] - data[i][1]
        alpha[i] = (3/h[i])*(data[i+1][2] - data[i][2])
    end

    l[1] = 1
    mu[1] = 0
    z[1] = 0

    for i = 2, n - 1 do
        l[i] = 2*(data[i+1][1] - data[i-1][1]) - h[i-1]*mu[i-1]
        mu[i] = h[i]/l[i]
        z[i] = (alpha[i-1] - h[i-1]*z[i-1])/l[i]
    end

    l[n] = 1
    z[n] = 0
    c[n] = 0

    for j = n-1, 1, -1 do
        c[j] = z[j] - mu[j]*c[j+1]
        b[j] = (data[j+1][2] - data[j][2])/h[j] - h[j]*(c[j+1] + 2*c[j])/3
        d[j] = (c[j+1] - c[j])/(3*h[j])
    end

    return {b, c, d}
end

-- Evaluates a cubic spline interpolant at the given x value
function evaluateSpline(x, data, spline)
    local n = #data
    local i = n-1
    while i > 0 and x <= data[i][1] do
        i = i - 1
    end

    local dx = x - data[i][1]
    local b = spline[1][i]
    local c = spline[2][i]
    local d = spline[3][i]

    return data[i][2] + b*dx + c*dx^2 + d*dx^3
end

-- Computes a cubic spline interpolant for the given data points and returns a function that can be used to evaluate it
function splineRegression(data)
    local spline = splineInterpolant(data)

    return function(x)
        return evaluateSpline(x, data, spline)
    end
end

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
    if not releasingEnabled then
        return
    end

    if not shotType then
        shotType = Character:GetAttribute("ShotType")
        
        if shotType == nil then
            notify("[ERROR] Auto-Release Cancelled", "ShotType is nil")
            return
        end
    end
    
    if not Timings[shotType] then
        notify("[ERROR] Auto-Release Cancelled", "ShotType not found in table")
        return
    end
    
    local startTime = clock()
    local function Shoot()
        print(calculateShotTiming(shotType, ping))
        if (clock() - startTime) >= calculateShotTiming(shotType, ping) then
            ClientAction:FireServer("Shoot", false)
            warn(string.format("Time taken: %.3f", clock() - startTime))
            RunService:UnbindFromRenderStep("Auto-Release")
        end
    end
    
    RunService:BindToRenderStep("Auto-Release", 0, Shoot)
end

local function onOverrideMouseIconBehavior()
    UserInputService.OverrideMouseIconBehavior = 1 -- ForceShow
end

local function onIdled() -- Anti-Idle
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
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

UserInputService:GetPropertyChangedSignal("OverrideMouseIconBehavior"):Connect(onOverrideMouseIconBehavior)
LocalPlayer.Idled:Connect(onIdled)
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if LocalPlayer.Character then
    onCharacterAdded()
end

task.defer(function()
    while task.wait() do
        renderAverage = FrameRateManager.RenderAverage:GetValue()
        frameTime_variance = FrameRateManager.FrameTimeVariance:GetValue()
        data_ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
    
        fps = 1000 / renderAverage
        fps_variation = (frameTime_variance / renderAverage) * 100
        
        data_split = string.split(data_ping, " ")
        
        ping = tonumber(data_split[1])
        ping_variance = tonumber(string.match(data_split[2], "%d+"))

        --print(string.format("FPS: %.2f   Variation: %.2f%%", fps, fps_variation))
        --warn(string.format("PING: %.2f  Variation: %.2f%%", ping, ping_variance))
    end
end)

print("Loaded")
