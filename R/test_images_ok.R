#' Test that all listed images in Dropbox/WarlpiriDictionaryFiles2017/wlp-dictionary-illustrations
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#' @param file_list output of rclone file listing
#'
#' @export
#'

test_images_ok <- function(wlp_lexicon, file_list = "illustrations.txt") {

    images_list <- readLines(file_list)

    wlp_lexicon %>%
        make_wlp_df() %>%
        filter(code1 == "img") %>%
        mutate(value = data %>%
                   str_remove_all(use_wlp_regex("all_codes")) %>%
                   str_remove_all(use_wlp_regex("source_codes")) %>%
                   str_trim()
        ) %>%
        separate_rows(value, sep = ",\\s?") %>%
        filter(!value %in% images_list) %>%
        rename(missing = value)

}
