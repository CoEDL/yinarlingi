#' Discard lines whose codes do not occur in the Warlpiri dictionary skeleton grammar
#'
#' @param wlp_df Warlpiri lexicon data frame (preferably piped in from \link{read_wlp_lexicon})
#' @param grammar_file a Nearley grammar file (default is `wlp_skeleton-simple.ne`)
#'
#' @importFrom dplyr filter sym
#' @importFrom purrr discard map
#' @importFrom stringr str_extract_all str_remove_all
#'
#' @export
#'

skeletonise_df <- function(wlp_df, grammar_file = system.file("structures/wlp_skeleton-simple.ne", package = "yinarlingi")) {

    skeleton_codes <-
        readLines(grammar_file) %>%
        str_remove_all("#.*$") %>%      # discard Nearley comments
        str_extract_all('"(.*?)"') %>%  # get the literals, e.g. '"ant"'
        unlist() %>%
        str_remove_all('"') %>%         # remove literals' double quotes, '"ant"' -> 'ant'
        sort()

    wlp_df %>%
        filter(code1 %in% skeleton_codes)

}
