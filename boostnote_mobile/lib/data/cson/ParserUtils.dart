class ParserUtils {

   String removeBrackets(String input) {
    String trimmedInput = input.trim();
    //Annahme, dass sowas {[ nicht gültig ist, d.h. list start { und object start [ müssen in zwei zeilen sein
    if(trimmedInput.startsWith('[')) {
      trimmedInput = trimmedInput.replaceFirst('[', '');
    }
    //Annahme, dass sowas }] nicht gültig ist, d.h. list end } und object end } müssen in zwei zeilen sein
    if(trimmedInput.endsWith(']')) {
       if(trimmedInput.length > 1) { 
        trimmedInput = trimmedInput.substring(0, trimmedInput.length-1);
      } else {
        trimmedInput = '';
      }
    }

    return trimmedInput;
  }

  String removeQuotationMarks(String input) {
    String cleandedInput = input.trim();
    if(cleandedInput.startsWith('\'\'\'')) {
      cleandedInput = cleandedInput.replaceFirst('\'\'\'', '');
    } else if(cleandedInput.startsWith('"')) {
      cleandedInput = cleandedInput.replaceFirst('"', '');
    }
    if(cleandedInput.endsWith('\'\'\'')) {
      if(cleandedInput.length > 3) {
        cleandedInput = cleandedInput.substring(0, cleandedInput.length-3);
      } else {
        cleandedInput = '';
      }
    } else if(cleandedInput.endsWith('"')) {
      if(cleandedInput.length > 1) {
        cleandedInput = cleandedInput.substring(0, cleandedInput.length-1);
      } else {
        cleandedInput = '';
      }
    }
    return cleandedInput;
  }
}