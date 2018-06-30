mainEntry       ->   "me" entryBody "eme"  senseEntry:* subEntry:*

subEntry        ->  "sse" entryBody "esse" senseEntry:*

senseEntry      ->   "se" entryBody "ese"
                |   "sub" entryBody "esub"

paradigmExample ->  "pdx" entryBody "epdx"
                |  "pdxs" entryBody "epdxs"

entryBody       -> "org":? "dm":* "def":? "lat":? "gl":? "rv":? "cm":*
                      (exampleBlock:+ | paradigmExample:+):?
                      crossRefs

exampleBlock    -> "eg" "cm":* examplePair:+ "eeg"

examplePair     -> ("we" | "wed") "et"

                   # Cross-reference codes listed in alphabetical order
crossRefs       -> "ant":? "cf":? "csl":? "pvl":? "syn":?
