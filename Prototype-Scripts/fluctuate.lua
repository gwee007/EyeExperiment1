function getClientInfo()
    return {
        name = "Fluctuate Between Notes",
        author = "Fyrebreak",
        category = "Fyre's Scripts",
        versionNumber = 1,
        minEditorVersion = 65537
    }
end

function main()
    local dialog = {
        title = "Fluctuate Between Notes",
        message = "Automating pitch down before an onset of notes, then shooting up at the onset to add attack to the note.",
        buttons = "OkCancel",
        widgets = {
            {
                name = "lowPeak",
                type = "Slider",
                label = "Maximum Tension",
                format = "%1.3f",
                minValue = -2,
                maxValue = 2,
                default = 1.280
            },
            {
                name = "highPeak",
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
            local selectedNotes = SV:getMainEditor():getSelection():getSelectedNotes()
            if #selectedNotes == 0 then
                return
            end
            local group = selectedNotes[1]:getParent()
            local param = group:getParameter("")
            local def = param:getDefinition()
            local default = def.defaultValue
            for i=1,#selectedNotes do
                local startPos = selectedNotes[i]:getOnset()
                local endPos = selectedNotes[i]:getEnd()
                local startValue = param:get(startPos)
                local endValue = param:get(endPos+1)
                local points = {}
                for j=startPos,endPos do
                    local value = param:get(j)
                    local t = (j-startPos)/(endPos-startPos)
                    local tension = result.lowPeak + (result.highPeak - result.lowPeak) * t
                    param:insert(j, tension)
                end
            end
        end
end
