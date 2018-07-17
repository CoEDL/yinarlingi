#' Test that reversal lines are well-formed
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @importFrom stringr str_detect str_remove_all
#' @importFrom purrr keep
#'
#' @export
#'

test_reversals_ok <- function(wlp_lexicon) {

    rv_test_func <- function(rv_string) {
        list(
            "consecutive carets"         = "\\^{2,}",
            "un-careted starting bracket" = "(?<!\\^)\\["
        ) %>%
        keep(~ str_detect(rv_string, .)) %>%
        names(.) %>%
        paste0(collapse = ", ")
    }

    wlp_lexicon %>%
        make_wlp_df() %>%
        filter(code1 == "rv") %>%
        mutate(
            data  = str_remove_all(data, use_wlp_regex("source_codes")),
            error = map_chr(data, rv_test_func)
        ) %>%
        filter(nzchar(error))

}
