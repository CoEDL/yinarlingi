mainEntry       ->   "me" entryBlock "eme"  senseEntry:* subEntry:*

subEntry        ->  "sse" entryBlock "esse" senseEntry:*

senseEntry      ->   "se" entryBlock "ese"
                |   "sub" entryBlock "esub"

paradigmExample ->  "pdx" entryBlock "epdx"
                |  "pdxs" entryBlock "epdxs"

entryBlock       -> "org":? "dm":* "def":? "lat":? "gl":? "rv":? "cm":*
                      (exampleBlock:+ | paradigmExample:+):?
                      crossRefs

exampleBlock    -> "eg" "cm":* examplePair:+ "eeg"

examplePair     -> ("we" | "wed") "et"

                   # Cross-reference codes listed in alphabetical order
crossRefs       -> "ant":? "cf":? "csl":? "pvl":? "syn":?
