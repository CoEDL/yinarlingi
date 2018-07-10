#' Test that listed attributes for entry blocks are well-formatted
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file

#' @export

test_block_attributes <- function(wlp_lexicon) {

    wlp_attrs_parser <- compile_grammar(system.file("structures/wlp_block-attributes.ne", package = "yinarlingi"))

    wlp_lexicon %>%
        make_wlp_df() %>%
        filter(code1 %in% c("me", "sse", "se", "sub")) %>%
        select(-code1) %>%
        mutate(
            attrs = str_remove(data, use_wlp_regex("me_sse_value")) %>%
                       str_remove(use_wlp_regex("pos_chunk")) %>%
                       str_remove_all(use_wlp_regex("source_codes")) %>%
                       str_remove("^\\\\[a-z]+") %>%
                       str_replace_all("\\s+", " ") %>%
                       str_trim(side = "right")
        ) %>%
        filter(nchar(str_trim(attrs)) > 0) %>%
        rowwise() %>%
        mutate(
            parse_result = wlp_attrs_parser$parse_str(attrs) %>% list(),
            error        = ifelse("error" %in% names(parse_result), parse_result$error, "none") %>%
                              str_remove("line 1 ")
        ) %>%
        filter(error != "none") %>%
        select(-parse_result)

}
