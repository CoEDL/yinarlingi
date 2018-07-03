#' Test whether all non-block codes have some content in them
#'
#' @param wlp_df a Warlpiri lexicon data frame
#'
#' @importFrom readr read_csv
#'
#' @export
#'

test_values_nonempty <- function(wlp_df) {

    wlp_code_defs <-
        read_csv(
            file      = system.file("structures/wlp_code-definitions.csv", package = "yinarlingi"),
            col_types = "ccc"
        )

    non_blocks <-
        filter(wlp_code_defs, str_detect(codes_expected, ";"))

    wlp_df %>%
        filter(code1 %in% c(non_blocks$code1, "we", "wed")) %>%
        mutate(content = str_remove_all(data, use_wlp_regex("all_codes")) %>% str_remove_all("source_codes") %>% str_trim()) %>%
        filter(nchar(content) == 0)

}
