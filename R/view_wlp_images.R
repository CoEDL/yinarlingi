#' View list of linked images in the Warlpiri dictionary
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @export
#'

view_wlp_images <- function(wlp_lexicon) {

    wlp_lexicon %>%
        make_wlp_df() %>%
        add_wlp_groups(c("me_or_sse", "se_or_sub")) %>%
        select(-line) %>%
        filter("img" %in% code1) %>%
        filter(code1 %in% c("img", "gl")) %>%
        mutate(data = str_remove_all(data, use_wlp_regex("all_codes")) %>% str_trim()) %>%
        spread(code1,data)

}
