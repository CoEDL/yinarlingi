#' @export

test_pos_strings <- function(wlp_df) {

    wlp_pos_values <-
        read_csv(
            file = system.file("structures/wlp_values_parts-of-speech.csv", package = "yinarlingi"),
            col_types = "cc"
        )

    wlp_df %>%
        filter(code1 %in% c("me", "sse")) %>%
        select(-code1) %>%
        mutate(
            pos_found  = str_extract(data, use_wlp_regex("pos_chunk")) %>%
                paste("'", ., "'", sep = "") %>%
                ifelse(. == "'NA'", "NA", .),

            pos_expected = pos_found %>%
                str_extract_all("\\(.*?\\)") %>%
                map(~ str_extract_all(., "[A-Z|a-z|\\-|:]+") %>% map(~ paste0(., collapse = ", "))) %>%
                map(~ paste0("(", ., ")")) %>%
                map_chr(~ paste0(., collapse = " ")) %>%
                paste("' ", ., ":'", sep = "") %>%
                ifelse(. == "' ():'", "NA", .) %>%
                I(),

            invalid_values = pos_found %>%
                str_remove(":'$") %>%
                str_extract_all("[A-Z|a-z|\\-|:]+") %>%
                map_chr(~ discard(., function(pos) pos %in% wlp_pos_values$value) %>% paste0(collapse = ", ")) %>%
                I()
        ) %>%
        filter(pos_found != pos_expected | nchar(invalid_values) > 0)

}

