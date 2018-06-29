#' View English-to-Warlpiri finder list
#'
#' @param wlp_df a Warlpiri lexicon data frame
#'
#' @importFrom tidyr unnest
#' @importFrom purrr map
#'
#' @export

view_wlp_reversals <- function(wlp_df) {

    wlp_df %>%
        # Keep only codes needed for making reversals table
        filter(code1 %in% c("rv", "me", "sse")) %>%

        # Overwrite existing groups, then re-group to prepare for reversalising
        ungroup() %>%
        add_wlp_groups(c("me_or_sse")) %>%

        ungroup %>%
        filter(code1 == "rv") %>%
        select(-code1) %>%

        mutate(          # '\gl car, cow \[HN:49] \egl' => 'car, cow'
            reversal   = data %>%
                            str_remove_all(use_wlp_regex("all_codes")) %>%
                            str_remove_all(use_wlp_regex("source_codes")),

                         # '1 : \sse ja*1* (N):' => 'ja*1*'
            wlp_parent = me_or_sse_start %>%
                            str_extract(use_wlp_regex("me_sse_value"))
        ) %>%

        # Separate comma-delimited glosses, e.g. 'car, cow', into individual rows
        select(reversal, wlp_parent) %>%

        mutate(reversal = map(reversal, ~ str_split(., use_wlp_regex("gloss_delim")) %>% unlist())) %>%
        unnest(reversal) %>%

        # Extract out parent data from gloss, e.g. '^[cry]cried' -> 'cry'
        mutate(eng_parent = ifelse(str_detect(reversal, "\\^"),
                                   str_extract_all(reversal, use_wlp_regex("eng_parent")),
                                   NA)
        ) %>%
        unnest(eng_parent) -> temp

        # Rest of the script is prettifiying the table for output
        temp %>% mutate(
            eng_parent = ifelse(is.na(eng_parent), reversal, str_remove_all(eng_parent, "[\\^\\[\\]@]")),
            rev_pretty = str_remove_all(reversal, "\\[.*?\\]") %>% str_remove_all("[\\^|@]")
        ) %>%
        separate_rows(eng_parent, sep = " && ") %>%
        mutate_all(str_trim) %>%

        group_by(eng_parent, rev_pretty) %>%
        summarise(
            wlp_words = wlp_parent %>% unique() %>% sort() %>% paste0(collapse = ", "),
            raw_revs  = reversal   %>% unique() %>% sort() %>% paste0(collapse = "; ")
        ) %>%
        ungroup() %>%

        mutate(rev_parent_same = eng_parent == rev_pretty) %>%
        arrange(eng_parent, desc(rev_parent_same), rev_pretty) %>%
        select(-rev_parent_same) %>%

        mutate(eng_parent = ifelse(duplicated(eng_parent), "", eng_parent))

}

