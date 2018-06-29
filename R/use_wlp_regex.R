#' Use a pre-defined regular expression for the Warlpiri Dictionary
#'
#' @param regex_name Name of regular expression to get, leave as NA to see the names. \link{yinarlingi}
#'
#' @export
#'

use_wlp_regex <- function(regex_name = NA) {

    # Creates a list 'wlp_regexes' in current scope (i.e. this function)
    sys.source(system.file("structures/wlp_regexes.R", package = "yinarlingi"))

    if(is.na(regex_name)) {

        names(wlp_regexes)

    } else {

        stopifnot(regex_name %in% names(wlp_regexes))
        stopifnot(length(regex_name) == 1)

        wlp_regexes[[regex_name]]

    }

}
