<cfcomponent><cfscript>

  function init() {
    _plurals = [];
    _singulars = [];
    _uncountables = "";

    _loadDefaultInflections();

    return this;
  }

  function pluralize(word) {
    var local = {};

    if (trim(word) eq "") return word;
    if (isUncountable(word)) return word;

    for (local.i = 1; local.i <= arrayLen(_plurals); local.i++) {
      local.pair = _plurals[local.i];
      if (reFindNoCase(local.pair.rule, word)) {
        return reReplaceNoCase(word, local.pair.rule, local.pair.replacement);
      }
    }

    return word;
  }

  function singularize(word) {
    var local = {};

    if (trim(word) eq "") return word;
    if (isUncountable(word)) return word;

    for (local.i = 1; local.i <= arrayLen(_singulars); local.i++) {
      local.pair = _singulars[local.i];
      if (reFindNoCase(local.pair.rule, word)) {
        return reReplaceNoCase(word, local.pair.rule, local.pair.replacement);
      }
    }

    return word;
  }

  function isUncountable(word) {
    return listFindNoCase(_uncountables, trim(word));
  }

  function plural(rule, replacement) {
    arrayPrepend(_plurals, arguments);
  }

  function singular(rule, replacement) {
    arrayPrepend(_singulars, arguments);
  }

  function irregular(singularWord, pluralWord) {
    var local = {};

    local.rule = reReplace(singularWord, "^(.)(.*)$", "(\1)\2$");
    local.replacement = reReplace(pluralWord, "^(.)(.*)$", "\\1\2");
    plural(local.rule, local.replacement);

    local.rule = reReplace(pluralWord, "^(.)(.*)$", "(\1)\2$");
    local.replacement = reReplace(singularWord, "^(.)(.*)$", "\\1\2");
    singular(local.rule, local.replacement);
  }

  function uncountable(words) {
    _uncountables = listAppend(_uncountables, words);
  }

  function _loadDefaultInflections() {
    plural("$", "s");
    plural("s$", "s");
    plural("(ax|test)is$", "\1es");
    plural("(octop|vir)us$", "\1i");
    plural("(alias|status)$", "\1es");
    plural("(bu)s$", "\1ses");
    plural("(buffal|tomat)o$", "\1oes");
    plural("([ti])um$", "\1a");
    plural("sis$", "ses");
    plural("(?:([^f])fe|([lr])f)$", "\1\2ves");
    plural("(hive)$", "\1s");
    plural("([^aeiouy]|qu)y$", "\1ies");
    plural("(x|ch|ss|sh)$", "\1es");
    plural("(matr|vert|ind)ix|ex$", "\1ices");
    plural("([m|l])ouse$", "\1ice");
    plural("^(ox)$", "\1en");
    plural("(quiz)$", "\1zes");

    singular("s$", "");
    singular("(n)ews$", "\1ews");
    singular("([ti])a$", "\1um");
    singular("((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$", "\1\2sis");
    singular("(^analy)ses$", "\1sis");
    singular("([^f])ves$", "\1fe");
    singular("(hive)s$", "\1");
    singular("(tive)s$", "\1");
    singular("([lr])ves$", "\1f");
    singular("([^aeiouy]|qu)ies$", "\1y");
    singular("(s)eries$", "\1eries");
    singular("(m)ovies$", "\1ovie");
    singular("(x|ch|ss|sh)es$", "\1");
    singular("([m|l])ice$", "\1ouse");
    singular("(bus)es$", "\1");
    singular("(o)es$", "\1");
    singular("(shoe)s$", "\1");
    singular("(cris|ax|test)es$", "\1is");
    singular("(octop|vir)i$", "\1us");
    singular("(alias|status)es$", "\1");
    singular("^(ox)en", "\1");
    singular("(vert|ind)ices$", "\1ex");
    singular("(matr)ices$", "\1ix");
    singular("(quiz)zes$", "\1");

    irregular("person", "people");
    irregular("man", "men");
    irregular("child", "children");
    irregular("sex", "sexes");
    irregular("move", "moves");

    uncountable("equipment,information,rice,money,species,series,fish,sheep");
  }

</cfscript></cfcomponent>
