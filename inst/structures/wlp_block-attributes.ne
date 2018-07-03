# Note that whitespace, '_WS', is significant!

# Example:    ' (H,La,Wi,Y) EXT: FIG: NEO: (lit. some text) (BT)'

attributes    -> dialectInfo:? semanticInfo:? literalInfo:?    registerInfo:?

dialectInfo   -> _WS "(" dialects ")"          # whitespace, dialects in parentheses

semanticInfo  -> _WS semanticType
              |  _WS semanticType semanticInfo # space-separated sem. types: ' EXT: IDIOM:'
             
registerInfo  -> _WS "(" registers ")"         # whitespace, registers in parentheses

literalInfo   -> _WS "(lit." [^\)]:+ ")"       # whitespace, '(lit.', followed by anything except ")", then a ')'

dialects      -> dialect                       # single dialect, e.g.  'H'
              |  dialect "," dialects          # comma-separated, e.g. 'La,Y'

registers     -> register                      # single register, e.g. 'BT'
              |  register "," registers        # comma-separated, e.g. 'BT,SL'

_WS           -> " "

dialect      -> "E"                            # Eastern Warlpiri
              | "H"                            # Hansen River
              | "La"                           # Lajamanu
              | "Ny"                           # Nyirrpi
              | "P"                            # Papunya
              | "Wi"                           # Willowra (Wirliyajarrayi)
              | "WW"                           # Wakirti Warlpiri (Alekarange/ Tennant Creek)
              | "Y"                            # Yuendumu (Yurntumu)

semanticType -> "EXT:"                         # extended meaning
              | "EXT: ASSOC:"                  # extended meaning, on basis of association (eg. 'head' used for 'hat')
              | "FIG:"                         # figurative meaning
              | "FUNCT:"                       # functional meaning (eg. 'ear' meaning 'ability to hear well')
              | "IDIOM:"                       # idiom
              | "NEO:"                         # neologism
              | "SYMB:"                        # symbolic

register     -> "BT"                           # Baby Talk
              | "SL"                           # Special Register Language
