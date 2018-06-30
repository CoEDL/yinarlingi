
alphabetise_wlp_file <- function(lexicon_file, output_file) {

    if(lexicon_file == output_file) {
        stop("Refusing to overwrite source file. Pick a different spot.")
    }

    read_wlp_lexicon(lexicon_file) %>%
        add_wlp_groups("me_only") %>%
        ungroup %>% # ungrouped mutate is faster
        mutate(
            me_parent = str_extract(me_start, use_wlp_regex("me_sse_value")),
            sort_key  = me_parent %>% str_remove("^-"),
            section   = sort_key  %>% str_extract("^[a-z|A-Z]")
        ) %>%
        arrange(section, sort_key, line) %>%

        # Add two empty lines at end of entry if none exists
        group_by(me_parent) %>%
        nest() %>%
        mutate(data = map_if(
            .x = data,
            .p = ~ !(tail(., n = 1) %>% .$code1 %>% is.na()),
            .f = ~ bind_rows(., tibble(line = max(.$line) + 0.5, data = "", code1 = NA))
        )) %>%
        unnest() %>%

        .$data %>%
        writeLines(output_file)

}
