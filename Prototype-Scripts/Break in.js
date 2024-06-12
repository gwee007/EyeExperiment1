function getClientInfo() {
    return {
        name: "Make Tense",
        category : "Tests",
        author: "impbox",
        versionNumber: 1,
        minEditorVersion: 0
    };
}

function main() {
    var selectedNotes = SV.getMainEditor().getSelection().getSelectedNotes();
    if (selectedNotes.length == 0) {
        SV.showMessageBox("Notice","No notes selected. Please select a note.");
        return;
    }

    var group = selectedNotes[0].getParent();
    var param = group.getParameter("tension");
    var def = param.getDefinition();
    var defaultValue = def.defaultValue;

    for (var i = 0; i < selectedNotes.length; i++) {
        var startPos = selectedNotes[i].getOnset();
        var endPos = selectedNotes[i].getEnd();
        var startValue = param.get(startPos);
        var postValue = param.get(endPos + 1);

        param.add(startPos, startValue);
        param.add(startPos + 1, def.range[0]); // Adjusted to 0-based indexing
        param.add(endPos, postValue);
    }

    SV.finish();
}
