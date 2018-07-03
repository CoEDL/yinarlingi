#' Test whether all expected codes (and only these) codes appear on a given line
#'
#' @param wlp_df a Warlpiri lexicon data frame
#'
#' @importFrom purrr map_chr
#' @importFrom readr read_csv
#'
#' @export
#'

test_inline_codes_ok <- function(wlp_df) {

    wlp_code_defs <-
        read_csv(
            file      = system.file("structures/wlp_code-definitions.csv", package = "yinarlingi"),
            col_types = "ccc"
        )

    wlp_df %>%
        # Prepare df for test
        ungroup %>%
        select(line, data, code1) %>%
        filter(code1 %in% wlp_code_defs$code1) %>%
        mutate(
            codes_found  = str_extract_all(data, "\\\\[^\\[\\s]+"),
            str_past_end = str_remove(data, "^\\\\") %>% # Wow, this was complicated to capture.
                stringi::stri_reverse() %>%              # get things past end code, e.g. '\\gl normal stuff here \\egl ...bad things here'
                str_extract(".*?(?=[a-z]+\\\\)") %>%
                stringi::stri_reverse() %>%
                str_trim() %>%
                ifelse(is.na(.), "", .),
            codes_found  = map_chr(codes_found, ~ paste0(., collapse = "; ") %>% str_remove_all("\\\\")),
            codes_found  = ifelse(nchar(str_past_end) > 0, paste(codes_found, str_past_end, sep = " "), codes_found)
        ) %>%

        # Do the test (leaving only rows that fail test)
        anti_join(
            y  = wlp_code_defs %>% rename(codes_found = codes_expected),
            by = "codes_found"
        ) %>%

        # Join with test expectations for feedback
        left_join(wlp_code_defs, by = "code1") %>%
        group_by(line, data, codes_found) %>%
        summarise(codes_expected = paste0(codes_expected, collapse = " or "))

}
