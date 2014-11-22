s = "10";
n = s instanceof string; // n = true
n = s instanceof int; // n = false
n = ( s = 10 ) instanceof int; // n = true