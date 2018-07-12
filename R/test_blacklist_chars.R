#' Test that no blacklisted characters appear in the lexicon
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @importFrom stringr str_detect
#'
#' @export
#'

test_blacklist_chars <- function(wlp_lexicon) {

    blacklist <- readr::read_csv(
        file = system.file("structures/wlp_values_blacklist.csv", package = "yinarlingi"),
        col_types = "cc"
    )

    all_regex <-
        blacklist %>%
        dplyr::pull(regex) %>%
        paste0(collapse = "|") %>%
        paste("(", ., ")", sep = "")

    result_df <-
        wlp_lexicon %>%
        make_wlp_df() %>%
        filter(str_detect(data, pattern = all_regex))

    if(nrow(result_df) > 0) {

        result_df$blacklisted_chars <-
            result_df$data %>%
            map_chr(function(error_line) {

                blacklist %>%
                    filter(str_detect(string = error_line, pattern = regex)) %>%
                    pull(description) %>%
                    paste0(collapse = "; ")

            })

    }

    result_df

}
