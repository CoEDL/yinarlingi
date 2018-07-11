#' Test whether left-most codes appear in expected order within the entries
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#' @param return_all return the all from data frame or just entries with errors (default is \code{FALSE})
#' @param grammar_file a Nearley grammar file (default is `wlp_skeleton-simple.ne`)
#'
#' @importFrom purrr map_int
#'
#' @export
#'

test_code1_ordered <- function(wlp_lexicon, return_all = FALSE, grammar_file = system.file("structures/wlp_skeleton-simple.ne", package = "yinarlingi")) {

    wlp_df <- make_wlp_df(wlp_lexicon)

    if(grepl("yinarlingi/structures/wlp_skeleton-simple\\.ne", grammar_file)) {

        # If using the default grammar, ensure that only expected grouping and codes are present
        wlp_df <- wlp_df %>%
            ungroup %>%
            skeletonise_df() %>%
            add_wlp_groups("me_only")
    }

    entry_parser <- compile_grammar(grammar_file)

    result_df <- wlp_df %>%
        mutate(code1_ok = entry_parser$parse_str(code1, return_labels = TRUE))

    if(!return_all) {
        result_df %>%
            filter(any(!code1_ok) | any(is.na(code1_ok))) %>%

            # Find out which line is failing, and get the 3 lines on either side of the failing line
            group_by(me_start) %>%
            nest() %>%
            mutate(failing_line = map_int(data, ~ filter(.,code1_ok == FALSE | is.na(code1_ok)) %>% slice(1) %>% pull(line))) %>%
            unnest(data,.drop = FALSE) %>%
            filter(line >= failing_line - 3, line <= failing_line + 3) %>%
            ungroup %>%
            mutate(
                me_start = ifelse(duplicated(me_start), "", me_start),
                error    = case_when(
                    code1_ok == FALSE                       ~ "Unexpected code1",
                    is.na(code1_ok) & lag(code1_ok) == TRUE ~ "Parse incomplete, expecting another code1 after."
                )
            ) %>%
            select(-failing_line)

    } else {
        result_df
    }

}
