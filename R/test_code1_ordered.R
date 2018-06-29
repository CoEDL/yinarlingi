#' Test whether left-most codes appear in expected order within the entries
#'
#' @param wlp_df a Warlpiri lexicon data frame
#' @param return_all return the all from data frame or just entries with errors (default is \code{FALSE})
#' @param grammar_file a Nearley grammar file (default is `wlp_skeleton-simple.ne`)
#'
#' @export
#'

test_code1_ordered <- function(wlp_df, return_all = FALSE, grammar_file = system.file("structures/wlp_skeleton-simple.ne", package = "yinarlingi")) {

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

    attr(result_df, "test_name") <- "code1_ordered"

    if(!return_all) {
        result_df %>%
            filter(any(!code1_ok))
    } else {
        result_df
    }

}
