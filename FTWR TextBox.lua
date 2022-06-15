script.Parent:GetPropertyChangedSignal("Text"):Connect(function()
	script.Parent.Text = script.Parent.Text:gsub('[^%d%.%-]', '');
end)
