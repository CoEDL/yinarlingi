wlp_regexes <- list(
    first_code = stringr::regex("^\\s*\\\\([a-z]+)"),

    last_code  = stringr::regex("\\\\([a-z]+)\\s*$"),

    all_codes  = stringr::regex("\\\\([a-z]+)"),

    # case I: '^cry'        -> 'cry'
    # case 2: '^[cry]cried' -> 'cry'
    eng_parent  = stringr::regex("
        (                   # match, either case I:
            \\^                 # a caret character
            [^\\s|\\[|\\)]+     # 1 or more, which are NOT a space, [, or ) character
        ) | (               # or, case II:
            \\^                 # a caret character followed by
            \\[.+?\\]           # 1 or more of any characters between square brackets [...]
        )
    ", comments = TRUE),

    # '\me jaala (PV): (H,Wi,Y)'  -> 'jaala'
    # '\sse jakarn-karri-mi (V):' -> 'jakarn-karri-mi'
    me_sse_value = stringr::regex("
        (?<=\\\\(me|sse)\\s)
        .+?                 # 1 or more of any character, up to
        (?=\\s\\([-|A-Z])   # a space, open parenthesis, an optional hyphen, and a capital letter
                            # i.e. part of speech, e.g. ' (N', ' (-V', etc.
    ", comments = TRUE),

    # '\gl' '\egl'
    gloss_codes = stringr::regex("
        \\\\                # backslash code
        e?                  # optional e prefix
        gl                  # gloss
    ", comments = TRUE),

    # 'car, boat'     -> c('car', 'boat')
    # 'of arm@, legs' -> c('of arm@, legs')
    gloss_delim = stringr::regex("
        (?<!@)              # negative lookbehind for '@' escape
        ,                   # comma
    ", comments = TRUE),

    # 'jaal(pa) (PV): (Y)'         -> '(PV)'
    # 'jaaljaal(pa) (N) (PV): (Y)' -> '(N) (PV)'
    pos_chunk = stringr::regex("
        (?<=\\s)            # space, positive look-behind
        \\(                 # open parenthesis
        -?[A-Z]             # uppercase character, optionally prefixed with '-'
        .*?                 # anything (non-greedy)
        \\)                 # close parenthesis
        (?=:)               # colon, positive look-ahead
      ", comments = TRUE),

    # '(PV)'     -> c('PV')
    # '(N) (PV)' -> c('N', 'PV')
    # '(N,V)'    -> c('N,V')
    pos_value = stringr::regex("
        (?<=\\()            # open parenthesis, positive look-behind
        .*?                 # anything (non-greedy)
        (?=\\))             # close parenthesis, positive look-ahead
        ", comments = TRUE),

    # '\[kn59]' '\[PPJ 10/87]'
    source_codes = stringr::regex("
        \\\\                # backslash code
        \\[                 # open square bracket
        .*?                 # anything, non-greedy
        \\]                 # close square bracket
    ", comments = TRUE)
)
