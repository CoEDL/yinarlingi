#' Test that all main- and sub-entry forms are unique
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @export
#'

test_entries_unique <- function(wlp_lexicon) {

    wlp_lexicon %>%
        make_wlp_df() %>%
        filter(code1 %in% c("me", "sse")) %>%
        mutate(entry_form = str_extract(data, use_wlp_regex("me_sse_value"))) %>%
        group_by(entry_form) %>%
        summarise(
            count   = n(),
            entries = paste0(data, collapse = ", ")
        ) %>%
        filter(count > 1)

}
