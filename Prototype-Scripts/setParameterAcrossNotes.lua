function getClientInfo()
    return {
        name = "Set Parameter Value Across Notes",
        author = "Fyrebreak",
        category = "Fyre's Scripts",
        versionNumber = 1,
        minEditorVersion = 0
    }
end

function main()
    local selection = SV:getMainEditor():getSelection():getSelectedNotes()
    if #selection == 0 then
        SV:showMessageBox("No notes selected", "Please select at least one note")
        return
    end
    local startPosition = selection[1]:getOnset()
    
    -- local startPositionBlicks = SV:getProject():getTimeAxis():getBlickFromSeconds(startPositionSecs)
    local group = selection[1]:getParent()
    local params = {"pitchDelta", "vibratoEnv", "loudness", "tension", "breathiness", "voicing", "gender", "toneShift"}
    local observedValues = {}
    
    for i=1,#params do
        local param = group:getParameter(params[i])
        local value = param:get(startPosition)
        table.insert(observedValues, value)
    end
    
    local dialog = {
        title = "Set Parameter Value Across Notes",
        message = "Set a value that will be applied to all notes in the selection. Default values are the first observed value in the notes you selected.",
        buttons = "OkCancel",
        widgets = {
            {
                name = "pitchEnable",
                type=  "CheckBox",
                text = "Check to Adjust Pitch",
                default = false
            },    
            {
                name = "pitchValue",
                type = "Slider",
                label = "Set Pitch Deviation",
                format = "%1.0f",
                minValue = -1200,
                maxValue = 1200,
                default = observedValues[1]
            },
            {
                name = "vibratoEnable",
                type=  "CheckBox",
                text = "Check to Adjust Vibrato",
                default = false
            },
            {
                name = "vibratoValue",
                type = "Slider",
                label = "Set Vibrato",
                format = "%1.2f",
                minValue = 0,
                maxValue = 2,
                default = observedValues[2]
            }
            ,
            {
                name = "loudnessEnable",
                type=  "CheckBox",
                text = "Check to Adjust Loudness",
                default = false
            },
            {
                name = "loudnessValue",
                type = "Slider",
                label = "Set Loudness",
                format = "%1.2f",
                minValue = -48,
                maxValue = 12,
                default = observedValues[3]
            },
            {
                name = "tensionEnable",
                type=  "CheckBox",
                text = "Check to Adjust Tension",
                default = false
            },
            {
                name = "tensionValue",
                type = "Slider",
                label = "Set Tension",
                format = "%1.3f",
                minValue = -2,
                maxValue = 2,
                default = observedValues[4]
            },
            {
                name = "breathinessEnable",
                type=  "CheckBox",
                text = "Check to Adjust Breathiness",
                default = false
            },
            {
                name = "breathinessValue",
                type = "Slider",
                label = "Set Breathiness",
                format = "%1.2f",
                minValue = -2,
                maxValue = 2,
                default = observedValues[5]
            },
            {
                name = "voicingEnable",
                type=  "CheckBox",
                text = "Check to Adjust Voicing",
                default = false
            },
            {
                name = "voicingValue",
                type = "Slider",
                label = "Set Voicing",
                format = "%1.2f",
                minValue = 0,
                maxValue = 1,
                default = observedValues[6]
            },
            {
                name = "genderEnable",
                type=  "CheckBox",
                text = "Check to Adjust Gender",
                default = false
            },
            {
                name = "genderValue",
                type = "Slider",
                label = "Set Gender",
                format = "%1.2f",
                minValue = -2,
                maxValue = 2,
                default = observedValues[7]
            },
            {
                name = "toneShiftEnable",
                type=  "CheckBox",
                text = "Check to Adjust Tone Shift",
                default = false
            },
            {
                name = "toneShiftValue",
                type = "Slider",
                label = "Set Tone Shift",
                format = "%1.2f",
                minValue = -800,
                maxValue = 800,
                default = observedValues[8]
            },
            {
                name= "easeFactor",
                type = "Slider",
                label = "Ease Period: Before and after each note",
                format = "%1.2f",
                minValue = 0,
                maxValue = 1,
                default = 0.1,
            }
         }
        }
    local result = SV:showCustomDialog(dialog)
    
    -- storing results in tables, so we can iterate through them

    local setValues = {}
    local setCheckboxes = {}
    table.insert(setValues, result.answers.pitchValue)
    table.insert(setValues, result.answers.vibratoValue)
    table.insert(setValues, result.answers.loudnessValue)
    table.insert(setValues, result.answers.tensionValue)
    table.insert(setValues, result.answers.breathinessValue)
    table.insert(setValues, result.answers.voicingValue)
    table.insert(setValues, result.answers.genderValue)
    table.insert(setValues, result.answers.toneShiftValue)

    table.insert(setCheckboxes, result.answers.pitchEnable)
    table.insert(setCheckboxes, result.answers.vibratoEnable)
    table.insert(setCheckboxes, result.answers.loudnessEnable)
    table.insert(setCheckboxes, result.answers.tensionEnable)
    table.insert(setCheckboxes, result.answers.breathinessEnable)
    table.insert(setCheckboxes, result.answers.voicingEnable)
    table.insert(setCheckboxes, result.answers.genderEnable)
    table.insert(setCheckboxes, result.answers.toneShiftEnable)
    
    local easeFactor = result.answers.easeFactor

    if result.status then
        for i=1,#selection do
            for j=1,#params do
                if setCheckboxes[j] then
                    if selection[i+1] and selection[i]:getEnd() == selection[i+1]:getOnset() then
                        SV:showMessageBox("Note", "Consecutive notes\n")
                        setConstantParameterOpen(selection[i+1], params[j], setValues[j], easeFactor)
                    else 
                        SV:showMessageBox("Note", "Non-consecutive notes")
                        setConstantParameterClose(selection[i], params[j], setValues[j], easeFactor)
                    end
                end
            end
        end
    end
    -- find out if consecutive notes are next to each other
    -- if they are, then the ease period cannot be applied in between consecutive notes
    -- if they are not, then the ease period can be applied in between consecutive notes

    SV:finish()
end

function setConstantParameterClose(note, parameter, value, easeFactor)
    -- SV:showMessageBox("Current Parameter", parameter)
    local group = note:getParent()
    local param = group:getParameter(parameter)
    -- setting transitions and defining the ease period
    local noteStart = note:getOnset()
    local noteEnd = note:getEnd()
    local noteLength = noteEnd - noteStart
    local easePeriod = easeFactor * noteLength
    local easeStart = note:getOnset() - easePeriod
    local easeEnd = note:getEnd() + easePeriod
    -- SV:showMessageBox("Ease Period", easePeriod .. "\n" .. easeStart .. "\n" .. easeEnd .. "\n" .. noteStart .. "\n" .. noteEnd)
    -- removing all prior automation points in the ease period
    local pointsArray = param:getPoints(easeStart, easeEnd)
    for i=1,#pointsArray do
        param:remove(pointsArray[i][1])
    end
    -- setting the value at the onset and end of the note
    -- SV:showMessageBox("Value", param:get(noteStart))
    SV:showMessageBox("Value", "Add value " .. param:get(easeStart) .. " to " .. easeStart)
    param:add(easeStart, param:get(easeStart))
    SV:showMessageBox("Value", "Add value " .. param:get(easeEnd) .. " to " .. easeEnd)
    param:add(easeEnd, param:get(easeEnd))
    SV:showMessageBox("Value", "Add value " .. value .. " to " .. noteStart)
    param:add(noteStart, value)
    SV:showMessageBox("Value", "Add value " .. value .. " to " .. noteEnd)
    param:add(noteEnd, value)
end

function setConstantParameterOpen(note, parameter, value, easeFactor)
    -- SV:showMessageBox("Current Parameter", parameter)
    local group = note:getParent()
    local param = group:getParameter(parameter)
    -- setting transitions and defining the ease period
    local noteStart = note:getOnset()
    local noteEnd = note:getEnd()
    local noteLength = noteEnd - noteStart
    local easePeriod = easeFactor * noteLength
    local easeStart = note:getOnset() - easePeriod
    local easeEnd = note:getEnd() + easePeriod
    -- SV:showMessageBox("Ease Period", easePeriod .. "\n" .. easeStart .. "\n" .. easeEnd .. "\n" .. noteStart .. "\n" .. noteEnd)
    -- removing all prior automation points in the ease period
    local pointsArray = param:getPoints(easeStart, easeEnd)
    for i=1,#pointsArray do
        param:remove(pointsArray[i][1])
    end
    -- setting the value at the onset and end of the note
    -- SV:showMessageBox("Value", param:get(noteStart))
    SV:showMessageBox("Value", "Add value " .. param:get(easeStart) .. " to " .. easeStart)
    param:add(easeStart, param:get(easeStart))
    --SV:showMessageBox("Value", "Add value " .. param:get(easeEnd) .. " to " .. easeEnd)
   --  param:add(easeEnd, param:get(easeEnd))
    SV:showMessageBox("Value", "Add value " .. value .. " to " .. noteStart)
    param:add(noteStart, value)
    SV:showMessageBox("Value", "Add value " .. value .. " to " .. noteEnd)
    param:add(noteEnd, value)
end

