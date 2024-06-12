function getClientInfo() {
    return {
      "name" : "Add exhale at start",
      "category" : "Fyre's Scripts",
      "author" : "Fyrebreak",
      "versionNumber" : 1,
      "minEditorVersion" : 65537
    };
  }

  function getAllPropertiesAsString(obj) {
    var propertiesString = '';
    for (var prop in obj) {
        if (Object.prototype.hasOwnProperty.call(obj, prop)) {
            propertiesString += prop + ": " + obj[prop] + "\n";
        }
    }
    return propertiesString;
  }

  
  function operation(){
    
    var selection = SV.getMainEditor().getSelection();
    var selectedNotes = selection.getSelectedNotes();
    
    if (selectedNotes.length == 0) {
        SV.showMessageBox("Notice","No notes selected. Please select a note.");
        return;
    }

    var currentGroupRef = SV.getMainEditor().getCurrentGroup();
    var groupPhonemes = SV.getPhonemesForGroup(currentGroupRef);

    var phonemes = [];
    for (var i = 0; i < selectedNotes.length; i++) {
        var noteIndex = selectedNotes[i].getIndexInParent();
        phonemes.push(groupPhonemes[noteIndex]);
    }

    var userInput = {
      "title" : "Adjust trail length",
      "message" : "Add 'hh' phoneme to notes' beginnings",
      "buttons" : "OkCancel",
      "widgets" : [
        /*{
            "name" : "override", "type" : "CheckBox",
            "text" : "Override values that are not at 100%",
            "default" : false
          },*/
        {
          "name" : "exhaleDuration", "type" : "Slider",
          "label" : "Exhale Duration Scale",
          "format" : "%1.0f",
          "minValue" : 20,
          "maxValue" : 180,
          "interval" :5,
          "default" : 100
        },
        {
          "name" : "exhaleStrength", "type" : "Slider",
          "label" : "Exhale Strength Scale",
          "format" : "%1.0f",
          "minValue" : 20,
          "maxValue" : 180,
          "interval" :5,
          "default" : 100
        }
      ]
    };
    
    var result = SV.showCustomDialog(userInput);

    if (!result.status) return;
    
    exhaleDuration = result.answers.exhaleDuration/100;
    exhaleStrength = result.answers.exhaleStrength/100;
   // var vowelBase = ["aa", "ae", "ah", "ao", "aw", "ax", "ay", "eh", "er", "ey", "ih", "iy", "ow", "oy", "uh", "uw"];
    //var consoBase = ["b", "ch", "d", "dx", "dr", "dh", "f", "g", "hh", "jh", "k", "l", "m", "n", "ng", "p", "r", "s", "sh", "t", "tr", "th", "v", "w", "y", "z", "zh"];
   // var silentBase = ["q", "dw", "tw", "cl", "pau", "sil", "br"];

    for (var i = 0; i < selectedNotes.length; i++){
        var notePhonemes = phonemes[i].split(" ");
        var noteNow=  selectedNotes[i];
        var durEdit = [];
        var strengthEdit = [];
         // SV.showMessageBox("Attempting list of properties", getAllPropertiesAsString(noteNow.getAttributes()));
         var duration = noteNow.getAttributes().dur;
         var strength = noteNow.getAttributes().strength;
         if (duration == NaN){
           for (var j = 0; j < notePhonemes.length; j++) {
             durEdit.push(1);
           }
         } else {
           durEdit = duration;
         }
         if (strength == NaN){
           for (var j = 0; j < notePhonemes.length; j++) {
             strengthEdit.push(1);
           }
         } else {
           strengthEdit = strength;
         }
        durEdit.unshift(exhaleDuration);
        strengthEdit.unshift(exhaleStrength); 
        notePhonemes.unshift("hh");
        var newPhonemes = notePhonemes.join(" ");
        noteNow.setPhonemes(newPhonemes);
        noteNow.setAttributes({
            "dur": durEdit,
            "strength": strengthEdit
        });
        // make new phoneme list
        }
    }

    /* if(result.status == "Yes") {
      SV.showMessageBox("Filled Form", "Slider value: " + result.answers.sl1);
      SV.showMessageBox("Filled Form", "ComboBox values: " +
        result.answers.cb1 + " and " + result.answers.cb2);
      SV.showMessageBox("Filled Form", "TextBox value: " + result.answers.tb1);
      SV.showMessageBox("Filled Form", "TextArea value: " + result.answers.ta1);
      SV.showMessageBox("Filled Form", "CheckBox1: " + result.answers.check1);
      SV.showMessageBox("Filled Form", "CheckBox2: " + result.answers.check2);*/
    
  function main() {
  
   operation();
    SV.finish();
  }