function getClientInfo() {
  return {
    "name": "Vowel-Consonant Mass Adjustment (CN)",
    "category": "Fyre's Scripts",
    "author": "Fyrebreak",
    "versionNumber": 1,
    "minEditorVersion": 65537
  };
}

function operation() {

  var selection = SV.getMainEditor().getSelection();
  var selectedNotes = selection.getSelectedNotes();
  if (selectedNotes.length == 0) {
    SV.showMessageBox("Notice", "No notes selected. Please select a note.");
    return;
  }
  var vowelBase = ["a", "A", "o", "@", "e", "7","U","u","i","i\\","i`","y","AU","@U","ia","iA","iAU","ie","iE","iU","iE","iU","i@U","y{","yE","ua","uA","u@","ue","uo"];
  var consoBase = [":\\i", "r\\`",":n","N","p","ph","t","th","k","kh","ts\\","ts","tsh","ts`","ts`h","x","f","s","s`","ts\\h","s\\","m","n","l","z`","w","j"];
  var silentBase = ["q", "dw", "tw", "cl", "pau", "sil", "br", "br1", "br2", "br3", "br4", "br5", "br6", "br7", "br8", "brl1", "brl2", "brl3", "brl4", "brl5", "brl6", "brl7", "brl8"];

  var currentGroupRef = SV.getMainEditor().getCurrentGroup();
  var groupPhonemes = SV.getPhonemesForGroup(currentGroupRef);

  var phonemes = [];
  for (var i = 0; i < selectedNotes.length; i++) {
    var noteIndex = selectedNotes[i].getIndexInParent();
    phonemes.push(groupPhonemes[noteIndex]);
  }
  var checkNote = selectedNotes[0];
  var vowelStrDefault = 1;
  var vowelDurDefault = 1;
  var breathStrDefault = 1;
  var breathDurDefault = 1;
  var consoStrDefault = 1;
  var consoDurDefault = 1;
  var vowelCheck = false;
  var consoCheck = false;
  var breathCheck = false;

  var extMessage;
  //if (vowelCheck || consoCheck || breathCheck) extMessage = "Changed default values set to the first instance of the detected phoneme type.";
  //else extMessage = "";
  var userInput = {
    "title": "Adjust phoneme length",
    "message": "Mass adjustment of vowels and consonants. \nPlease enter the desired scale for each phoneme type.",
    "buttons": "OkCancel",
    "widgets": [{
        "name": "vowelDuration",
        "type": "Slider",
        "label": "Vowel Duration Scale (in %)",
        "format": "%1.0f",
        "minValue": 20,
        "maxValue": 180,
        "interval": 5,
        "default": vowelDurDefault * 100
      },
      {
        "name": "consonantDuration",
        "type": "Slider",
        "label": "Consonant Duration Scale (in %)",
        "format": "%1.0f",
        "minValue": 20,
        "maxValue": 180,
        "interval": 5,
        "default": consoDurDefault * 100
      },
      {
        "name": "breathDuration",
        "type": "Slider",
        "label": "Breath Duration Scale (in %)",
        "format": "%1.0f",
        "minValue": 20,
        "maxValue": 180,
        "interval": 5,
        "default": breathDurDefault * 100
      },
      {
        "name": "vowelStrength",
        "type": "Slider",
        "label": "Vowel Strength Scale (in %)",
        "format": "%1.0f",
        "minValue": 20,
        "maxValue": 180,
        "interval": 5,
        "default": vowelStrDefault * 100
      },
      {
        "name": "consonantStrength",
        "type": "Slider",
        "label": "Consonant Strength Scale (in %)",
        "format": "%1.0f",
        "minValue": 20,
        "maxValue": 180,
        "interval": 5,
        "default": consoStrDefault * 100
      },
      {
        "name": "breathStrength",
        "type": "Slider",
        "label": "Breath Strength Scale (in %)",
        "format": "%1.0f",
        "minValue": 20,
        "maxValue": 180,
        "interval": 5,
        "default": breathStrDefault * 100
      },
    ]
  };

  var result = SV.showCustomDialog(userInput);

  if (result.status == "Cancel") return;

  for (var i = 0; i < selectedNotes.length; i++) {
    var notePhonemes = phonemes[i].split(" ");
    var durEdit = [];
    var strEdit = [];
    for (var j = 0; j < notePhonemes.length; j++) {
      var lengths = selectedNotes[i].getAttributes().dur;
      var strengths = selectedNotes[i].getAttributes().strength;
      var phoneme = notePhonemes[j];
      if (checkNote.getAttributes().dur.length < 1) {
        // No one knows if this array is actually empty or not, so this is actually all redundant.
        if (vowelBase.indexOf(phoneme) > -1) {
          durEdit.push(result.answers.vowelDuration / 100);
        } else if (consoBase.indexOf(phoneme) > -1) {
          durEdit.push(result.answers.consonantDuration / 100);
        } else if (silentBase.indexOf(phoneme) > -1) {
          durEdit.push(result.answers.breathDuration / 100);
        }
      } else {
        // SV.showMessageBox("Notice", "Phoneme: " + phoneme + "\nDur: " + lengths[j] + "\nStr: " + strengths[j]);
        if (vowelBase.indexOf(phoneme) > -1) {
          if (lengths[j] == null) {
            lengths[j] = 1;
          }
          var temp = lengths[j] * result.answers.vowelDuration / 100;
          if (temp < 0.20) {
            temp = .20;
          } else if (temp > 1.80) {
            temp = 1.80;
          }
          durEdit.push(temp);
        } else if (consoBase.indexOf(phoneme) > -1) {
          if (lengths[j] == null) {
            lengths[j] = 1;
          }
          var temp = lengths[j] * result.answers.consonantDuration / 100;
          if (temp < 0.20) {
            temp = 0.20;
          } else if (temp > 1.80) {
            temp = 1.80;
          }
          durEdit.push(temp);
        } else if (silentBase.indexOf(phoneme) > -1) {
          if (lengths[j] == null) {
            lengths[j] = 1;}
          var temp = lengths[j] * result.answers.breathDuration / 100;
          if (temp < 0.20) {
            temp = 0.20;
          } else if (temp > 1.80) {
            temp = 1.80;
          }
          durEdit.push(temp);
        }
      }

      if (checkNote.getAttributes().strength.length < 1) {     
        // No one knows if this array is actually empty or not, so this is actually all redundant.   
        if (vowelBase.indexOf(phoneme) > -1) {
          strEdit.push(result.answers.vowelStrength / 100);
        } else if (consoBase.indexOf(phoneme) > -1) {
          strEdit.push(result.answers.consonantStrength / 100);
        } else if (silentBase.indexOf(phoneme) > -1) {
          strEdit.push(result.answers.breathStrength / 100);
        }
      } else {
        if (vowelBase.indexOf(phoneme) > -1) {
         // SV.showMessageBox("Notice", "Phoneme: " + phoneme + "\nDur: " + lengths[j] + "\nStr: " + strengths[j]);
          if (strengths[j] == null) {
            strengths[j] = 1;
          }

          var temp = strengths[j] * result.answers.vowelStrength / 100;
          if (temp < .20) {
            temp = .20;
          } else if (temp > 1.80) {
            temp = 1.80;
          }
          strEdit.push(temp);
        } else if (consoBase.indexOf(phoneme) > -1) {
          if (strengths[j] == null) {
            strengths[j] = 1;
          }

          var temp = strengths[j] * result.answers.consonantStrength / 100;
          if (temp < 0.20) {
            temp = 0.20;
          } else if (temp > 1.80) {
            temp = 1.80;
          }
          strEdit.push(temp);
        } else if (silentBase.indexOf(phoneme) > -1) {
          if (strengths[j] == null) {
            strengths[j] = 1;
          }

          var temp = strengths[j] * result.answers.breathStrength / 100;
          if (temp < 0.20) {
            temp = 0.20;
          } else if (temp > 1.80) {
            temp = 1.80;
          }
          strEdit.push(temp);
        }
      }
    }
    // SV.showMessageBox("Notice", "Phoneme: " + notePhonemes + "\nDur: " + durEdit + "\nStr: " + strEdit);
    selectedNotes[i].setAttributes({
      "dur": durEdit,
      "strength": strEdit
    });
  }
}

function main() {
  operation();
  //SV.showMessageBox("Notice", "Operation complete.");
  SV.finish();
}
