#' Test that cross-references do not contain references to themselves
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @importFrom tidyr separate_rows
#'
#' @export
#'

test_xrefs_noselfref <- function(wlp_lexicon) {

    make_wlp_df(wlp_lexicon) %>%
        add_wlp_groups("me_or_sse") %>%
        ungroup %>%
        filter(code1 %in% c("ant", "cf", "syn")) %>%
        mutate(value = data %>%
                   str_remove_all(use_wlp_regex("all_codes")) %>%
                   str_remove_all(use_wlp_regex("source_codes")) %>%
                   str_trim()
        ) %>%
        separate_rows(value, sep = ",\\s?") %>%
        mutate(me_or_sse_value = str_extract(me_or_sse_start, use_wlp_regex("me_sse_value"))) %>%
        filter(value == me_or_sse_value) %>%
        select(line, data, selfref = value)

}
