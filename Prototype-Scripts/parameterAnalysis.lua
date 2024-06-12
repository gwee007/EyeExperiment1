function getClientInfo()
    return {
        name = "Show Parameter Values At Playhead",
        author = "Fyrebreak",
        category = "Fyre's Scripts",
        versionNumber = 1,
        minEditorVersion = 0
    }
end
function main()
    
    local playbackPositionSecs = SV:getPlayback():getPlayhead()
    local playbackPositionBlicks = SV:getProject():getTimeAxis():getBlickFromSeconds(playbackPositionSecs)
    local group = SV:getMainEditor():getCurrentGroup():getTarget()
    local params = {"pitchDelta", "vibratoEnv", "loudness", "tension", "breathiness", "voicing", "gender", "toneShift"}
    local observedValues = {}
    
    for i=1,#params do
        local param = group:getParameter(params[i])
        local value = param:get(playbackPositionBlicks)
        table.insert(observedValues, value)
    end
    local message = "Pitch Deviation: " .. observedValues[1] .. "\nVibrato Envelope: " .. observedValues[2] .. "\nLoudness: " .. observedValues[3] .. "\nTension: " .. observedValues[4] .. "\nBreathiness: " .. observedValues[5] .. "\nVoicing: " .. observedValues[6] .. "\nGender: " .. observedValues[7] .. "\nTone Shift:" .. observedValues[8] .. "\nPosition in Blicks: " .. playbackPositionBlicks .."\nPosition in Seconds: " .. playbackPositionSecs

    SV:showMessageBox("Parameter Values At Playhead", message)
end
