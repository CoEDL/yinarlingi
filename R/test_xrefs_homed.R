#' Test that no cross-references are orphaned in the Warlpiri dictionary
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @importFrom tidyr separate_rows
#'
#' @export
#'

test_xrefs_homed <- function(wlp_lexicon) {

    wlp_df <- make_wlp_df(wlp_lexicon)

    whitelist_df <- wlp_df %>%
        filter(code1 %in% c("me", "sse")) %>%
        mutate(value = str_extract(data, use_wlp_regex("me_sse_value"))) %>%
        select(value)

    crossrefs_df <- wlp_df %>%
        filter(code1 %in% c("ant", "cf", "syn")) %>%
        mutate(value = data %>%
                          str_remove_all(use_wlp_regex("all_codes")) %>%
                          str_remove_all(use_wlp_regex("source_codes")) %>%
                          str_trim()
               ) %>%
        separate_rows(value, sep = ",\\s?")

    anti_join(
        x  = crossrefs_df,
        y  = whitelist_df,
        by = "value"
    ) %>%
    group_by(line, data) %>%
    summarise(orphaned_values = paste0(value, collapse = ", "))

}
