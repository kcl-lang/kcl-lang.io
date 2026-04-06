(function (Prism) {
  Prism.languages.kcl = {
    comment: [
      {
        pattern: /#[^\n]*/,
        lookbehind: false,
      },
    ],
    string: [
      {
        pattern: /r?(""".*?(?<!\\)(\\\\)*?"""|'''.*?(?<!\\)(\\\\)*?''')/is,
        greedy: true,
      },
      {
        pattern: /r?("(?!"").*?(?<!\\)(\\\\)*?"|'(?!'').*?(?<!\\)(\\\\)*?')/i,
        greedy: true,
      },
    ],
    keyword: /\b(?:import|as|rule|schema|mixin|protocol|check|for|assert|if|elif|else|or|and|not|in|is|lambda|all|any|filter|map|type)\b/,
    "reserved-keyword": /\b(?:pass|return|def|class|final|raise|from|with|try|except|finally|while|yield|del|global|nonlocal|struct|flow|validate)\b/,
    boolean: /\b(?:True|False)\b/,
    builtin: /\b(?:int|float|bool|str|any)\b/,
    constant: /\b(?:None|Undefined)\b/,
    number: [
      // Float
      /(([-+]?\d+\.\d*|\.\d+)(e[-+]?\d+)?|\d+(e[-+]?\d+))/i,
      // Hex
      /\-?0[xX][0-9a-fA-F]+/i,
      // Octal
      /\-?0[oO]?[0-7]+/i,
      // Binary
      /\-?0[bB][0-1]+/i,
      // Integers with unit multipliers (n, u, m, k, K, M, G, T, P, Ki, Mi, Gi, Ti, Pi)
      /\b[0-9][0-9_]*(?:n|u|m|k|K|M|G|T|P|Ki|Mi|Gi|Ti|Pi)?\b/,
      // Decimal
      /\-?0|\-?[1-9]\d*/i,
    ],
    decorator: {
      pattern: /@[a-zA-Z_]\w*/,
    },
    "class-name": {
      pattern: /(\b(?:schema|mixin|protocol|rule)\s+)[A-Za-z_]\w*/,
      lookbehind: true,
    },
    function: /(?<![a-z_]\b)\b[a-z_]\w*(?=\s*\()/i,
    operator: /[-+*/%^&|<>!=]=?|~|(?:>>|<<|\/\/|\*\*)=?/,
    punctuation: /[{}[\],.:@?]/,
  };
})(Prism);
