#' Test that latin/scientific name(s) lines are well-formed
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @importFrom stringr str_detect str_remove_all
#' @importFrom purrr keep
#'
#' @export
#'

test_latin_ok <- function(wlp_lexicon) {

    lat_test_func <- function(lat_string) {
        list(
            "latin @l inside lat field"   = "@l",
            "unparenthesised ?"           = "((?<!\\()\\? | \\?(?!\\)))"
        ) %>%
            keep(~ str_detect(lat_string, .)) %>%
            names(.) %>%
            paste0(collapse = ", ")
    }

    wlp_lexicon %>%
        make_wlp_df() %>%
        filter(code1 == "lat") %>%
        mutate(
            data  = str_remove_all(data, use_wlp_regex("source_codes")),
            error = map_chr(data, lat_test_func)
        ) %>%
        filter(nzchar(error))

}
