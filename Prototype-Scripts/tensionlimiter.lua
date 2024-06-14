function getClientInfo()
    return {
        name = "Tension Clip To Value",
        author = "Fyrebreak",
        category = "Fyre's Scripts",
        versionNumber = 1,
        minEditorVersion = 0
    }
end


function main()
    local dialog = {
        title = "Tension Clip To Value",
        message = "Set a maximum/minimum tension value for the selected notes",
        buttons = "OkCancel",
        widgets = {
            {
                name = "maxtension",
                type = "Slider",
                label = "Maximum Tension",
                format = "%1.3f",
                minValue = -2,
                maxValue = 2,
                default = 1.280
            },
            {
                name = "mintension",
                type = "Slider",
                label = "Minimum Tension",
                format = "%1.3f",
                minValue = -2,
                maxValue = 2,
                default = -1.8
            }
        
        }
    }
    local result = SV:showCustomDialog(dialog)
    if result.status then
        -- SV:showMessageBox("Result", "Proceed")
        local selectedNotes = SV:getMainEditor():getSelection():getSelectedNotes()
        if #selectedNotes == 0 then
            -- SV:showMessageBox("No notes selected", "Please select at least one note")
            return
        end
        local group = selectedNotes[1]:getParent()
        local param = group:getParameter("tension")
        local def = param:getDefinition()
        local default = def.defaultValue
       
        for i=1,#selectedNotes do
    
            local startPos = selectedNotes[i]:getOnset()
            local endPos = selectedNotes[i]:getEnd()
            local startValue = param:get(startPos)
            local endValue = param:get(endPos+1)
            -- SV:showMessageBox("Note", "Start: " .. startPos .. " End: " .. endPos)
            --[[Array of points, from start position to end position]]
            local points = param:getPoints(startPos, endPos)
            -- SV:showMessageBox("Note", i)
            for j=1,#points do
                -- SV:showMessageBox("Point", points[j][1] .. " " .. points[j][2])
                local value = points[j][2]
                if value > result.answers.maxtension then
                    param:add(points[j][1], result.answers.maxtension)
                elseif value < result.answers.mintension then
                    param:add(points[j][1], result.answers.mintension)
                end
            param:add(startPos, startValue)
            param:add(endPos, endValue)
            end
            local startValue = param:get(startPos)
            local postValue = param:get(endPos+1)
            -- [[param:add(startPos, startValue) param:add(startPos+1, def.range[2] param:add(endPos, postValue)
        end
    end
    SV:finish()
end

