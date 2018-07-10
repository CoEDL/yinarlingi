#' Test whether all left-most codes are defined (i.e. no stray codes from typos)
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @importFrom dplyr filter
#'
#' @export
#'

test_all_codes_defined <- function(wlp_lexicon) {

    wlp_code_defs <-
        read_csv(
            file      = system.file("structures/wlp_code-definitions.csv", package = "yinarlingi"),
            col_types = "ccc"
        )

    wlp_lexicon %>%
        make_wlp_df %>%
        filter(!is.na(code1), !code1 %in% wlp_code_defs$code1)

}
