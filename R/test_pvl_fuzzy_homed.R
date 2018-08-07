#' Test that cross-references to preverbs have a fuzzily-matching parent
#'
#' For a given preverb, e.g. 'jurlkuly-' we search for whether various approximate forms, e.g.
#' 'jurlkuly', 'jurlkulyku', 'jurlkuly-ku', 'jurlkuly(pa)', or 'jurlkulypa' can be found as a
#' main- or sub-entry (e.g. \code{\\me jurlkuly(pa)})
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @importFrom tidyr separate_rows
#'
#' @export
#'

test_pvl_fuzzy_homed <- function(wlp_lexicon) {

    wlp_df <- make_wlp_df(wlp_lexicon)

    whitelist_df <- wlp_df %>%
        filter(code1 %in% c("me", "sse")) %>%
        mutate(value = str_extract(data, use_wlp_regex("me_sse_value"))) %>%
        select(value)

    preverbs_df <- wlp_df %>%
        filter(code1 == "pvl") %>%
        mutate(pvl_form = data %>%
                   str_remove_all(use_wlp_regex("all_codes")) %>%
                   str_remove_all(use_wlp_regex("source_codes")) %>%
                   str_trim()
        ) %>%
        separate_rows(pvl_form, sep = ",\\s?") %>%
        mutate(value = map(pvl_form, make_fuzzy_forms)) %>%
        unnest()

    anti_join(
        x  = preverbs_df,
        y  = whitelist_df,
        by = "value"
    ) %>%
    group_by(line, data) %>%
    summarise(orphaned_pvls = paste0(unique(pvl_form), collapse = ", "))

}

make_fuzzy_forms <- function(pvl_form) {

    pvl_form %>%
        str_remove("-$") %>%
        paste(c("", "ku", "-ku", "pa", "(pa)"), sep = "")

}
