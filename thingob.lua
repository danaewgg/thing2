    --discord.gg/boronide, code generated using luamin.js™
    
    -- Only execute after you've spawned in
    
    getgenv().danhubDebug = true
    
    local Workspace = game:GetService("Workspace")
    local Stats = game:GetService("Stats")
    local UserInputService = game:GetService("UserInputService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TeleportService = game:GetService('TeleportService')
    
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Ping = Stats.PerformanceStats.Ping
    
    local Character = LocalPlayer.Character
    
    local remotePath = ReplicatedStorage.GameEvents
    local Args = {
    	...
    }
    local Method = getnamecallmethod()
    
    local usedTable = "tblTimings40"
    local useEquation = false
    
    local tblResources = {
    	tblMeter = {
    		settingShotMeter = LocalPlayer.PlayerGui.SocialUI.Settings.Frame.List.ShotMeters.Button.Label,
    		Size = Character.ShotMeterUI.Meter.Bar.Size.Y.Scale
    	},
    	tblReleases = {
    		["Too-Late Release"] = 1.3,
    		["Slightly-Late Release"] = 1.15,
    		["Perfect Release"] = 1,
    		["Good Release"] = 1.05,
    		["Slightly-Early Release"] = 0.95,
    		["Too-Early Release"] = 0.5
    	}
    }
        
    getgenv().tblSettings = {
    	Signature = "[danhub]",
    	autoRelease = true,
    	autoArcade = false,
    	tblTimings40 = {
    		["Standing Shot"] = 0.875,
    		["Off Dribble Shot"] = 0.865,
    		["Drift Shot"] = 0.85,
    		["Far Shot"] = 0.835,
    		["Freethrow"] = 0.8,
    		["Hopstep Off Dribble Shot"] = 0.88,
    		["Hopstep Drift Shot"] = 0.81,
    		["Layup"] = 0.845,
    		["Reverse Layup"] = 0.835,
    		["Hopstep Layup"] = 0.845,
    		["Eurostep Layup"] = 0.84,
    		["Dropstep Layup"] = 0.845,
    		["Post Layup"] = 0.79,
    		["Floater"] = 0.835,
    		["Hopstep Floater"] = 0.8,
    		["Eurostep Floater"] = 0.8,
    		["Close Shot"] = 0.8,
    		["Hopstep Close Shot"] = 0.8,
    		["Dropstep Close Shot"] = 0.79,
    		["Post Close Shot"] = 0.8,
    		["AlleyOop Close Shot"] = 0.79,
    		["Standing Dunk"] = 0.8,
    		["Hopstep Standing Dunk"] = 0.8,
    		["Post Standing Dunk"] = 0.8,
    		["Driving Dunk"] = 0.82,
    		["AlleyOop Standing Dunk"] = 0.77,
    		["AlleyOop Driving Dunk"] = 0.77,
    		["Post Fade"] = 0.85,
    		["Drift Post Fade"] = 0.85,
    		["Hopstep Post Fade"] = 0.85,
    		["Dropstep Post Fade"] = 0.85,
    		["Post Hook"] = 0.865,
    		["Hopstep Post Hook"] = 0.8,
    		["Dropstep Post Hook"] = 0.8
    	},
    	tblTimings100 = {
    		["Standing Shot"] = 0.66,
    		["Off Dribble Shot"] = 0.685,
    		["Drift Shot"] = 0.63,
    		["Far Shot"] = 0.5,
    		["Freethrow"] = 0.7,
    		["Hopstep Off Dribble Shot"] = 0.6,
    		["Hopstep Drift Shot"] = 0.63,
    		["Layup"] = 0.55,
    		["Reverse Layup"] = 0.549,
    		["Hopstep Layup"] = 0.549,
    		["Eurostep Layup"] = 0.525,
    		["Dropstep Layup"] = 0.53,
    		["Post Layup"] = 0.555,
    		["Floater"] = 0.55,
    		["Hopstep Floater"] = 0.57,
    		["Eurostep Floater"] = 0.565,
    		["Close Shot"] = 0.5,
    		["Hopstep Close Shot"] = 0.55,
    		["Dropstep Close Shot"] = 0.55,
    		["Post Close Shot"] = 0.55,
    		["AlleyOop Close Shot"] = 0.5,
    		["Standing Dunk"] = 0.6,
    		["Hopstep Standing Dunk"] = 0.3,
    		["Post Standing Dunk"] = 0.6,
    		["Driving Dunk"] = 0.6,
    		["AlleyOop Standing Dunk"] = 0.449,
    		["AlleyOop Driving Dunk"] = 0.449,
    		["Post Fade"] = 0.635,
    		["Drift Post Fade"] = 0.62,
    		["Hopstep Post Fade"] = 0.61,
    		["Dropstep Post Fade"] = 0.61,
    		["Post Hook"] = 0.59,
    		["Hopstep Post Hook"] = 0.515,
    		["Dropstep Post Hook"] = 0.505
    	},
    	tblTimings160 = {
            	["Standing Shot"] = 0.35,
            	["Off Dribble Shot"] = 0.36,
            	["Drift Shot"] = 0.343,
            	["Far Shot"] = 0.15,
            	["Freethrow"] = 0.4,
            	["Hopstep Off Dribble Shot"] = 0.35,
            	["Hopstep Drift Shot"] = 0.325,
            	["Layup"] = 0.25,
            	["Reverse Layup"] = 0.24,
            	["Hopstep Layup"] = 0.25,
            	["Eurostep Layup"] = 0.25,
            	["Dropstep Layup"] = 0.25,
            	["Post Layup"] = 0.245,
            	["Floater"] = 0.24,
            	["Hopstep Floater"] = 0.25,
            	["Eurostep Floater"] = 0.2,
            	["Close Shot"] = 0.24,
            	["Hopstep Close Shot"] = 0.21,
            	["Dropstep Close Shot"] = 0.21,
            	["Post Close Shot"] = 0.23,
            	["AlleyOop Close Shot"] = 0.17, 
            	["Standing Dunk"] = 0.24,
            	["Hopstep Standing Dunk"] = 0.24,
    	        ["Post Standing Dunk"] = 0.24,
    	        ["Driving Dunk"] = 0.25,
            	["AlleyOop Standing Dunk"] = 0.17,
            	["AlleyOop Driving Dunk"] = 0.17,
            	["Post Fade"] = 0.305,
            	["Drift Post Fade"] = 0.315,
            	["Hopstep Post Fade"] = 0.305,
            	["Dropstep Post Fade"] = 0.305,
            	["Post Hook"] = 0.27,
            	["Hopstep Post Hook"] = 0.22,
            	["Dropstep Post Hook"] = 0.22,
            },
    	tblTimings200 = {
    		["Standing Shot"] = 0.38,
    		["Off Dribble Shot"] = 0.395,
    		["Drift Shot"] = 0.37,
    		["Far Shot"] = 0.25,
    		["Freethrow"] = 0.4,
    		["Hopstep Off Dribble Shot"] = 0.39,
    		["Hopstep Drift Shot"] = 0.36,
    		["Layup"] = 0.32,
    		["Reverse Layup"] = 0.31,
    		["Hopstep Layup"] = 0.31,
    		["Eurostep Layup"] = 0.285,
    		["Dropstep Layup"] = 0.29,
    		["Post Layup"] = 0.3,
    		["Floater"] = 0.305,
    		["Hopstep Floater"] = 0.29,
    		["Eurostep Floater"] = 0.27,
    		["Close Shot"] = 0.28,
    		["Hopstep Close Shot"] = 0.26,
    		["Dropstep Close Shot"] = 0.259,
    		["Post Close Shot"] = 0.26,
    		["AlleyOop Close Shot"] = 0.08,
    		["Standing Dunk"] = 0.35,
    		["Hopstep Standing Dunk"] = 0.3,
    		["Post Standing Dunk"] = 0.31,
    		["Driving Dunk"] = 0.38,
    		["AlleyOop Standing Dunk"] = 0.08,
    		["AlleyOop Driving Dunk"] = 0.08,
    		["Post Fade"] = 0.36,
    		["Drift Post Fade"] = 0.365,
    		["Hopstep Post Fade"] = 0.36,
    		["Dropstep Post Fade"] = 0.36,
    		["Post Hook"] = 0.31,
    		["Hopstep Post Hook"] = 0.275,
    		["Dropstep Post Hook"] = 0.275
    	}
    }
    
    local function getMeterSetting()
    	if tblResources.tblMeter["settingShotMeter"].ContentText then
    		return tblResources.tblMeter["settingShotMeter"].ContentText
    	else
    		print(tblSettings.Signature, "Something went wrong with getMeterSetting()")
    		return
    	end
    end
    
    local function getShotType()
    	if Character:GetAttribute("ShotType") then
    		return Character:GetAttribute("ShotType")
    	elseif not Character:GetAttribute("ShotType") then
    		repeat
    			task.wait()
    		until Character:GetAttribute("ShotType")
    		return Character:GetAttribute("ShotType")
    	else
    		print(tblSettings.Signature, "Something went wrong with getShotType()")
    		return
    	end
    end
    
    local function getShotMeter()
    	if Character:GetAttribute("ShotMeter") then
    		return Character:GetAttribute("ShotMeter")
    	elseif not Character:GetAttribute("ShotMeter") then
    		repeat
    			task.wait()
    		until Character:GetAttribute("ShotMeter")
    		return Character:GetAttribute("ShotMeter")
    	else
    		warn(tblSettings.Signature, "Something went wrong with getShotMeter()")
    		return
    	end
    end
    
    local function getLandedShotMeter()
    	if Character:GetAttribute("LandedShotMeter") then
    		return Character:GetAttribute("LandedShotMeter")
    	elseif not Character:GetAttribute("LandedShotMeter") then
    		repeat
    			task.wait()
    		until Character:GetAttribute("LandedShotMeter")
    		return Character:GetAttribute("LandedShotMeter")
    	else
    		print(tblSettings.Signature, "Something went wrong with getLandedShotMeter()")
    		return
    	end
    end
    
    local function getRelease()
        local releaseType = "Unknown Release"
        if getLandedShotMeter() <= tblReleases["Too-Late Release"] then
            releaseType = "Too-Late Release"
        elseif getLandedShotMeter() <= tblReleases["Slightly-Late Release"] then
            releaseType = "Slightly-Late Release"
        elseif getLandedShotMeter() <= tblReleases["Perfect Release"] then
            releaseType = "Perfect Release"
        elseif getLandedShotMeter() <= tblReleases["Good Release"] then
            releaseType = "Good Release"
        elseif getLandedShotMeter() <= tblReleases["Slightly-Early Release"] then
            releaseType = "Slightly-Early Release"
        elseif getLandedShotMeter() <= tblReleases["Too-Early Release"] then
            releaseType = "Too-Early Release"
        end
        return releaseType
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
        if not getgenv().tblSettings.autoRelease then
            return
        end
    
        if not shotType then
            shotType = Character:GetAttribute("ShotType")
            
            if shotType == nil then
                notify("[ERROR] Auto-Release Cancelled", "ShotType is nil")
                return
            end
        end
        
        local releaseTime = Timings[shotType]
        if not releaseTime then
            notify("[ERROR] Auto-Release Cancelled", "ShotType not found in table")
            return
        end
        
        local startTime = os.clock()
        local function Shoot()
            if (os.clock() - startTime) >= releaseTime then
                ClientAction:FireServer("Shoot", false)
                warn(string.format("Time taken: %.3f", os.clock() - startTime))
                RunService:UnbindFromRenderStep("Auto-Release")
            end
        end
    
        local hasStreak = Character:GetAttribute("Streak")
        if hasStreak then
            local streakMeter = Character:GetAttribute("StreakMeter")
            local streakType = Character:GetAttribute("StreakType")
    
            if shotType == "Standing Shot" or shotType == "Off Dribble Shot" or shotType == "Hopstep Off Dribble Shot" then
                if streakMeter > 0 and streakType == "Spot-Up Shooter" then
                    releaseTime = releaseTime - 0.05 -- Spot-Up timing
                elseif streakMeter < 0 then
                    releaseTime = releaseTime + 0.03 -- Cold timing
                end
            end
        end
    
        local isQuickShot = Boosts:FindFirstChild("Quick Shot")
        if isQuickShot and isQuickShot:GetAttribute("Activated") then
            local quickShotTier = Character.Boosts["Quick Shot"].Value
            releaseTime = releaseTime - quickShotTimings[quickShotTier]
        end
        
        RunService:BindToRenderStep("Auto-Release", 0, Shoot)
    end
    
    local function aimbotPrep()
    	if Character:GetAttribute("ShotType") ~= nil and tblSettings.autoRelease then
    		if getMeterSetting() ~= "Off" then -- Not off
    			print(tblSettings.Signature, "Calling meterPerfect")
    			autoRelease()
    		elseif getMeterSetting() == "Off" then -- Off
    			print(tblSettings.Signature, "Calling noMeterPerfect")
    			autoRelease()
    		else
    			warn(tblSettings.Signature, "Something went wrong with the ShootingAnim function")
    		end
    	end
    end
    
    local function defineVariables()
    	Character = LocalPlayer.Character
    	tblResources.tblMeter["Size"] = Character("ShotMeterUI.Meter.Bar.Size.Y.Scale")
    end
    
    local function connectMain()
    	Character = LocalPlayer.Character
    	Character:GetAttributeChangedSignal("ShootingAnim"):Connect(aimbotPrep)
    	Character:GetAttributeChangedSignal("AlleyOop"):Connect(aimbotPrep)
    	pcall(defineVariables())
    	pcall(aimbotPrep())
    end
    
    Character = LocalPlayer.Character
    Character:GetAttributeChangedSignal("ShootingAnim"):Connect(aimbotPrep)
    Character:GetAttributeChangedSignal("AlleyOop"):Connect(aimbotPrep)
    
    LocalPlayer.CharacterAdded:Connect(connectMain)
    
    local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/miroeramaa/TurtleLib/main/TurtleUiLib.lua"))()
    
    local window = library:Window("Main")
    
    local window2 = library:Window("Timings")
    
    window:Toggle("Perfect Release", true, function(bool)
        if bool then
    	    autoRelease = bool
    	else
    	   autoRelease = false
    	end
    	print(tblSettings.Signature, "Perfect Release:", bool)
    end)
    
    window:Button("Rejoin", function()
    	if # Players:GetPlayers() <= 1 then
    		LocalPlayer:Kick("\nRejoining, one second...")
    		task.wait()
    		TeleportService:Teleport(game.PlaceId, LocalPlayer)
    	else
    		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    	end
    end)
    
    window2:Toggle("40 ping timings", true, function(bool40)
    	print(bool40) -- bool is true or false depending on the state of the toggle
        --if bool40 and (bool200 or bool100) then
            --bool200 or bool100 = false
            --usedTable = "tblTimings40"
        --end
    	if bool40 then
    		usedTable = "tblTimings40"
    	else
    		usedTable = nil
    	end
    end)
    
    window2:Toggle("100 ping timings", false, function(bool100)
    	print(bool100) -- bool is true or false depending on the state of the toggle
        --if bool100 and (bool200 or bool40) then
            --(bool40 or bool200) = false
            --usedTable = "tblTimings100"
        --end
    	if bool100 then
    		usedTable = "tblTimings100"
    	else
    		usedTable = nil
    	end
    end)
    
    window2:Toggle("160 ping timings", false, function(bool160)
    	print(bool200) -- bool is true or false depending on the state of the toggle
        --if bool200 and (bool100 or bool40) then
            --(bool100 or bool40) = false
            --usedTable = "tblTimings200"
        --end
    	if bool160 then
    		usedTable = "tblTimings160"
    	else
    		usedTable = nil
    	end
    end)
    
    window2:Toggle("200 ping timings", false, function(bool200)
    	print(bool200) -- bool is true or false depending on the state of the toggle
        --if bool200 and (bool100 or bool40) then
            --(bool100 or bool40) = false
            --usedTable = "tblTimings200"
        --end
    	if bool200 then
    		usedTable = "tblTimings200"
    	else
    		usedTable = nil
    	end
    end)
    
    window2:Label("make sure to disable the toggle \nbefore enabling another one", true)
    
    print(tblSettings.Signature, "Loaded")
    
        local function runArcade()
            local onMachine = game:GetService("Workspace")["Arcade Machine"]:GetAttribute("InGame")
                    while not onMachine do
    	        print("onMachine1", onMachine)
            	local distanceLimit = 20
            	local currentDistance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - game:GetService("Workspace")["Arcade Machine"].Spawn.Position).magnitude
            	if currentDistance < distanceLimit then
                    workspace["Arcade Machine"].Remotes.Play:FireServer()
            	end
            	task.wait(5)
                    end
	   end
    
        window:Toggle("Arcade Joiner", false, function()
        runArcade()
        if game:GetService("Workspace")["Arcade Machine"] then
            game:GetService("Workspace")["Arcade Machine"]:GetAttributeChangedSignal("InGame"):Connect(function()
            onMachine = game:GetService("Workspace")["Arcade Machine"]:GetAttribute("InGame")
            runArcade()
        end)
        end
        end)
