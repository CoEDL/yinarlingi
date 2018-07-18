#' (Re-)alphabetise the Warlpiri dictionary file
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @importFrom purrr map_if map2
#'
#' @export

alphabetise_wlp_file <- function(wlp_lexicon, output_file) {

    if(wlp_lexicon == output_file) {
        stop("Refusing to overwrite source file. Pick a different file path.")
    }

    sort_func <- function(sort_df, parent_col) {
        sort_df %>%
            ungroup %>% # ungrouped mutate is faster
            mutate(
                parent     = str_extract(!!enquo(parent_col), use_wlp_regex("me_sse_value")),
                hm_no      = str_extract(parent, "\\*\\d\\*") %>% str_remove_all("\\*") %>% as.integer(),
                sort_key   = parent %>% str_remove("^-") %>% str_remove_all("\\*\\d\\*") %>% str_to_lower(),
                i_upper    = str_extract(sort_key, "^[a-z]") != str_remove(str_extract(parent, "^-?[A-Z|a-z]"), "-"),
                i_nohyphen = str_extract(parent, "^-") %>% is.na() %>% `!`,
                section    = sort_key  %>% str_to_lower() %>% str_extract("^(ng|ny|rd|[a-z])")
            ) %>%
            arrange(section, sort_key, i_nohyphen, i_upper, hm_no, line) %>%
            select(-parent, -section, -sort_key, -i_upper, -i_nohyphen, -hm_no)
    }

    return_df <-
        wlp_lexicon %>%
        # make_wlp_df() %>%
        add_wlp_groups("me_only") %>%
        sort_func(parent_col = me_start) %>%
        add_wlp_groups("me_or_sse") %>%
        ungroup %>%
        mutate(in_sse = me_start != me_or_sse_start) %>%
        group_by(me_start, in_sse) %>%
        nest()

    return_df$data <-
        map2(return_df$in_sse, return_df$data, function(in_sse, data) {
            if(in_sse) {
                data %>% sort_func(me_or_sse_start)
            } else {
                data
            }
        })

    return_df %>%
        unnest() %>%
        # Remove all empty lines (i.e. if they've moved around after realphabetisation)
        filter(nzchar(str_remove_all(data, "\\s+"))) %>%
        # Add empty line at end of entry
        group_by(me_start) %>%
        nest() %>%
        mutate(data = map(data, ~ bind_rows(., tibble(data = "")))) %>%
        unnest() %>%

        .$data %>%
        writeLines(output_file)

}
