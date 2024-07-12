Component("image", function(component, name)
	if name then
		component.source = Assets:get("image", name)
	else
		component.source = nil
	end
end)
