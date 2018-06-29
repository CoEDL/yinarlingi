#' Read in and optionally pre-process the Warlpiri lexicon file
#'
#' @param lexicon_path location of the wlp-lexicon_master.txt file.
#' @param preprocess extract out the left-most backslash code of each line into a \code{code1} column? Default is \code{TRUE}

#' @importFrom tidylex read_lexicon
#'
#' @export
#'

read_wlp_lexicon <- function(lexicon_path, preprocess = TRUE) {

    if(!preprocess) {

        read_lexicon(file  = lexicon_path)

    } else {

        read_lexicon(
            file  = lexicon_path,
            regex = use_wlp_regex("first_code"),
            into  = "code1"
        )
    }

}
