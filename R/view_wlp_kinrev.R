#' View Warlpiri (kin terms)-to-English finder list
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @importFrom purrr map2_lgl
#'
#' @export
#'

view_wlp_kinrev <- function(wlp_lexicon) {
 
    wlp_lexicon %>%
        make_wlp_df() %>%
        
        filter(
            code1 %in% c(
                "me", "sse", "se", "sub", # sense-level codes for groupings
                "rv",                     # glosses for making the reversals
                "lat",                    # code(s) for pre-filtering
                "dm"
            )
        ) %>% 
        add_wlp_groups(c("me_or_sse", "se_or_sub")) %>%
        mutate(
            has_lat = "lat" %in% code1,
            of_kin  = map2_lgl(code1, data, ~ .x == "dm" && grepl("kin:", .y)) %>% any()
        ) %>% 
        filter(!has_lat, of_kin) %>%  # filter out flora/fauna which have latin names
        ungroup %>%
        select(line, data, code1) %>%
        view_wlp_reversals()
       
}