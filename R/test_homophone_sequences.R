#' Test that all homophones numbers well-sequenced across the homophonous entry forms
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @export
#'

test_homophone_sequences <- function(wlp_lexicon) {

    wlp_lexicon %>%
        make_wlp_df() %>%
        filter(code1 %in% c("me", "sse")) %>%
        mutate(
            entry_form = str_extract(data, use_wlp_regex("me_sse_value")),
            hm_number  = str_extract(entry_form, "(?<=\\*)\\d(?=\\*)"),
            bare_form  = str_remove(entry_form, "\\*\\d+\\*")
        ) %>%
        group_by(bare_form) %>%
        summarise(
            all_forms   = paste0(entry_form, collapse = ", "),
            ns_found    = paste0(hm_number, collapse = ", "),
            ns_expected = seq(1, length(hm_number)) %>% paste0(collapse = ", "),
            form_alone  = length(hm_number) == 1
        ) %>%
        filter(grepl("\\*", all_forms)) %>%
        filter(form_alone | (!form_alone & ns_found != ns_expected))

}
