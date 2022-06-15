local PluginBar = plugin:CreateToolbar("FTWR Beta")
local PluginButton1 = PluginBar:CreateButton("FTWR", "Open FTWR GUI.", "http://www.roblox.com/asset/?id=436101586", "FTWR Open")
local Opened = false

local MainWidgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Left,
	false,
	false,
	300,
	500,
	300,
	500
)
local MainWidget = plugin:CreateDockWidgetPluginGui("FTWR", MainWidgetInfo)
MainWidget.Title = "FTWR Beta"

NormalWidget = script.Parent.MainScreenGui

NormalWidget.Parent = MainWidget

PluginButton1.Click:Connect(function()
	if Opened then
		MainWidget.Enabled = false
		Opened = false
		
		NormalWidget.CreateNewRigPage.Visible = false
		NormalWidget.Page1.Visible = true
		
	else
		MainWidget.Enabled = true
		Opened = true
		
		local PopUpScript = Instance.new("Script")
		PopUpScript:Destroy()
	end
end)


local OriginPart = "No One"
local TargetPart = "No One"
local selectedparts = {}


NormalWidget.Page1.TextButton.MouseButton1Click:Connect(function()
	NormalWidget.Page1.Visible = false
	NormalWidget.CreateNewRigPage.Visible = true
end)

NormalWidget.CreateNewRigPage.SelectOriginButton.MouseButton1Click:Connect(function()
	if game.Selection:Get()[1] and game.Selection:Get()[1]:IsA("BasePart") then
		OriginPart = game.Selection:Get()[1]
		NormalWidget.CreateNewRigPage.OriginFrame.OriginTextLabel.Text = game.Selection:Get()[1].Name
	else
		OriginPart = "No One"
		NormalWidget.CreateNewRigPage.OriginFrame.OriginTextLabel.Text = "Instance"
	end
end)

NormalWidget.CreateNewRigPage.SelectTargetButton.MouseButton1Click:Connect(function()
	if game.Selection:Get()[1] and game.Selection:Get()[1]:IsA("BasePart") then
		TargetPart = game.Selection:Get()[1]
		NormalWidget.CreateNewRigPage.TargetFrame.TargetTextLabel.Text = game.Selection:Get()[1].Name
	else
		TargetPart = "No One"
		NormalWidget.CreateNewRigPage.TargetFrame.TargetTextLabel.Text = "Instance"
	end
end)

NormalWidget.CreateNewRigPage.SelectPartsButton.MouseButton1Click:Connect(function()
	table.remove(selectedparts)
	
	for _, v in pairs(NormalWidget.CreateNewRigPage.RigPartsFrame.RigPartsScrollingFrame:GetDescendants()) do
		if not v:IsA("UIGridLayout") then
			v:Destroy()
		end
	end
	
	if #game.Selection:Get() > 0  then
		for i, v in pairs(game.Selection:Get()) do
			if v:IsA("BasePart") then
				v.Name = i
				table.insert(selectedparts,v)
				
				local newExampleFrame = NormalWidget.CreateNewRigPage.RigPartsFrame.ExampleFrame:Clone()
				newExampleFrame.ExampleFrameTextLabel.Text = tostring(v.Name)
				
				
				newExampleFrame.Parent = NormalWidget.CreateNewRigPage.RigPartsFrame.RigPartsScrollingFrame
				
				newExampleFrame.Visible = true
			end
		end
	end
end)





NormalWidget.CreateNewRigPage.CreateScriptButton.MouseButton1Click:Connect(function()
	if #selectedparts > 0 and OriginPart ~= "No One" and TargetPart ~= "No One" and #NormalWidget.CreateNewRigPage.spacebetweenTextBox.Text > 0 then
		local newMainFolder = Instance.new("Folder",game.Workspace)
		newMainFolder.Name = "FTWR_BETA_folder"
		local newRigFolder = Instance.new("Folder",newMainFolder)
		newRigFolder.Name = "Rig_folder"
		
		for i,v in pairs(selectedparts) do
			v.Parent = newRigFolder
		end
		
		OriginPart.Name = "OriginPart"
		TargetPart.Name = "TargetPart"
		
		OriginPart.Parent = newMainFolder
		TargetPart.Parent = newMainFolder
		
		local newScript = Instance.new("Script",newMainFolder)
		newScript.Source =
			'local betweengipsvalue ='..tostring(NormalWidget.CreateNewRigPage.spacebetweenTextBox.Text)..'\nlocal origin = script.Parent.OriginPart\nlocal target = script.Parent.TargetPart\n\nlocal segments = {}\nfor _, v in pairs(script.Parent["Rig_folder"]:GetDescendants()) do\nif v:IsA("BasePart") then\ntable.insert(segments, v)\nend\nend\n\n\nlocal function ms(nSegment, tp)\n nSegment.CFrame = CFrame.lookAt((nSegment.CFrame * CFrame.new(0,0, 2.5)).Position, tp)\n nSegment.CFrame *= CFrame.new(0,0, -(tp - (nSegment.CFrame * CFrame.new(0,0, betweengipsvalue)).Position).Magnitude) \n end \n\n\n\n while wait() do \n for i = #segments,1,-1 do \n if i == #segments then \n ms(segments[#segments], target.Position) \n else \n ms(segments[i],(segments[i+1].CFrame * CFrame.new(0,0,2.5)).Position) \nend \n\n local off = ((segments[1].CFrame * CFrame.new(0,0,2.5)).Position - origin.Position) \n\n for i = #segments, 1, -1 do \n segments[i].Position -= off \n end \n end \nend'
		
		
		OriginPart = "No One"
		TargetPart = "No One"
		
		table.remove(selectedparts)
		
		NormalWidget.CreateNewRigPage.OriginFrame.OriginTextLabel.Text = "Instance"
		NormalWidget.CreateNewRigPage.TargetFrame.TargetTextLabel.Text = "Instance"
		NormalWidget.CreateNewRigPage.spacebetweenTextBox.Text = ""
		
		
		for i,v in pairs(NormalWidget.CreateNewRigPage.RigPartsFrame.RigPartsScrollingFrame:GetDescendants()) do
			if not v:IsA("UIGridLayout") then
				v:Destroy()
			end
		end
		
		
		NormalWidget.CreateNewRigPage.Visible = false
		NormalWidget.Page1.Visible = true
		
		
	end
end)
