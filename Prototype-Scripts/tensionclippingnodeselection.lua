function getClientInfo()
    return {
        name = "Tension Clip: Selection Prototype",
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
    local cleared = SV:getMainEditor():getSelection()
    
   --  local result = SV:showCustomDialog(dialog)}

end