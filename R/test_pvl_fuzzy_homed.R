#' Test that cross-references to preverbs have a fuzzily-matching parent
#'
#' For a given preverb, e.g. 'jurlkuly-' we search for whether various approximate forms, e.g.
#' 'jurlkuly', 'jurlkulyku', 'jurlkuly-ku', 'jurlkuly(pa)', or 'jurlkulypa' can be found as a
#' main- or sub-entry (e.g. \code{\\me jurlkuly(pa)})
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @importFrom tidyr separate_rows
#' @importFrom purrr keep
#'
#' @export
#'

test_pvl_fuzzy_homed <- function(wlp_lexicon) {

    wlp_df <- make_wlp_df(wlp_lexicon)

    whitelist <- wlp_df %>%
        filter(code1 %in% c("me", "sse")) %>%
        mutate(value = str_extract(data, use_wlp_regex("me_sse_value"))) %>%
        pull(value)

    # Allowing extra fuzziness for 11th hour fixing of the lexicon
    whitelist <- c(
        whitelist,
        # Remove all homophone numbers
        whitelist %>% keep(~ str_detect(., "\\*\\d\\*")) %>% str_remove_all("\\*\\d\\*") %>% unique()
    )

    whitelist <- c(
        whitelist,
        # Remove all non-alphabetic characters
        whitelist %>% str_remove_all("[^a-z|A-Z]+") %>% unique()
    )

    # append preverbs to start of parent verb
    # see https://github.com/CoEDL/yinarlingi/issues/2
    whitelist <- c(
        whitelist,
        wlp_df %>%
            add_wlp_groups(c("me_only")) %>%
            ungroup %>% filter(code1 == "pvl") %>%
            mutate(pvl = data %>% str_remove_all(use_wlp_regex("all_codes")) %>%
                       str_remove_all(use_wlp_regex("source_codes")) %>%
                       str_trim(), me = str_extract(me_start, use_wlp_regex("me_sse_value"))) %>%
            separate_rows(pvl, sep = ",\\s?") %>%
            mutate(full_form = paste(pvl, me, sep = "-") %>%
                       str_replace_all("-+", "-")) %>%
            pull(full_form)
    )

    wlp_df %>%
        filter(code1 == "pvl") %>%
        mutate(pvl_form = data %>%
                   str_remove_all(use_wlp_regex("all_codes")) %>%
                   str_remove_all(use_wlp_regex("source_codes")) %>%
                   str_trim()
        ) %>%
        separate_rows(pvl_form, sep = ",\\s?") %>%
        mutate(value = map(pvl_form, make_fuzzy_forms)) %>%
        unnest() %>%
        mutate(value_ok = value %in% whitelist) %>%
        group_by(line, data, pvl_form) %>%
        filter(all(!value_ok)) %>%
        group_by(line, data) %>%
        summarise(orphaned_pvls = paste0(unique(pvl_form), collapse = ", "))

}

make_fuzzy_forms <- function(pvl_form) {

    pvl_form %>%
        str_remove("-$") %>%
        paste(c("", "ku", "-ku", "pa", "(pa)"), sep = "") %>%
        c(., str_remove_all(., "[^a-z|A-Z]+") %>% unique())

}
