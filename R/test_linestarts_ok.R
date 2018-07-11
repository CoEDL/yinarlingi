#' Test that all non-empty lines start with either a backslash or \code{@}
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @export
#'

test_linestarts_ok <- function(wlp_lexicon) {

    wlp_lexicon %>%
        make_wlp_df() %>%
        filter(
            is.na(code1),
            !grepl("^@", data),
            nchar(str_trim(data)) > 0
        ) %>%
        select(-code1)

}
