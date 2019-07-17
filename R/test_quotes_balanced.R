#' Test that double quotes are well-balanced
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @importFrom stringr str_extract_all
#'
#' @export
#'

test_quotes_balanced <- function(wlp_lexicon) {

    wlp_lexicon %>%
        skeletonise_df() %>%
        mutate(num_quots = str_count(data, '"')) %>%
        filter(num_quots > 0, num_quots %% 2 != 0)

}
