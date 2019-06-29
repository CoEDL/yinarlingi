#' View scientific name to Warlpiri finder list
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#'
#' @importFrom purrr map2_lgl
#'
#' @export
#'

view_wlp_scirev <- function(wlp_lexicon) {

    wlp_lexicon %>%
        make_wlp_df() %>%

        ungroup() %>%

        add_wlp_groups("me_or_sse") %>%
        filter("lat" %in% code1) %>%                  # note this is a grouped filter (group = me_or_sse_start)!

        ungroup() %>%
        filter(code1 %in% c("dm", "lat", "gl")) %>%

        group_by(me_or_sse_start) %>%
        mutate(
            dm = lag(data),
            gl = lead(data)
        ) %>%
        ungroup() %>%
        filter(code1 == "lat") %>%
        mutate(
            Class = case_when(
                str_detect(dm, "flora") ~ "Flora",
                str_detect(dm, "fungus") ~ "Fungus",
                str_detect(dm, "fauna") ~ "Fauna",
                TRUE ~ "Other"
            ) %>%
                factor(levels = c("Other", "Fauna", "Flora", "Fungus"))
        ) %>%
        mutate(
            Subclass = case_when(
                Class %in% c("Flora", "Fungus")            ~ "",
                str_detect(dm, "(mammal|yumurru\\-kurlu)") ~ "Mammals",
                str_detect(dm, "(mammal|yumurru\\-wangu)") ~ "Reptiles",
                str_detect(dm, "(bird|jurlpu)")            ~ "Birds",
                str_detect(dm, "insect")                   ~ "Insects",
                str_detect(dm, "crustacea")                ~ "Crustaceans",
                str_detect(dm, "frog")                     ~ "Frogs",
                str_detect(dm, "arachnid")                 ~ "Arachnids",
                TRUE                                       ~ "Other fauna"
            ) %>%
                factor(levels = c("", "Arachnids","Birds","Crustaceans","Frogs","Insects","Mammals","Reptiles","Other fauna")),
            Latin    = get_wlp_value(data),
            Common   = get_wlp_value(gl),
            Warlpiri = str_extract(me_or_sse_start, use_wlp_regex("me_sse_value"))
        )%>%
        select(Class, Subclass, Latin, Common, Warlpiri) %>%
        separate_rows(Latin, sep = ",\\s?") %>%
        group_by(Class, Subclass, Latin, Common) %>%
        summarise(Warlpiri = unique(Warlpiri) %>% sort() %>% paste0(collapse = ", ")) %>%

        ungroup() %>%
        mutate_at(vars(Class, Subclass, Latin), funs(ifelse(duplicated(.), "", as.character(.))))

}

get_wlp_value <- function(str) {
    str %>%
        str_remove_all(use_wlp_regex("all_codes")) %>%
        str_remove_all(use_wlp_regex("source_codes")) %>%
        str_remove_all("\\^") %>%
        str_trim()
}
