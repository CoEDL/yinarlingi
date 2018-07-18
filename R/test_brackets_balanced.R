#' Test that all brackets and parentheses are well-balanced
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @importFrom stringr str_extract_all
#'
#' @export
#'

test_brackets_balanced <- function(wlp_lexicon) {

    wlp_lexicon %>%
        skeletonise_df() %>%
        mutate(
            data = str_remove_all(data, use_wlp_regex("source_codes")),
            l_bracs  = map_chr(data, ~ str_extract_all(., "[<|\\(|\\[]") %>% unlist(use.names = FALSE) %>% paste0(collapse  = "")),
            r_bracs  = map_chr(data, ~ str_extract_all(., "[>|\\)|\\]]") %>% unlist(use.names = FALSE) %>% paste0(collapse  = "")),
            bracs_ok = nchar(l_bracs) == nchar(r_bracs)
        ) %>%
        filter(!bracs_ok)

}
