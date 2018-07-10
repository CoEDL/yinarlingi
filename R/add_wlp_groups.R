#' Add grouping columns to a Warlpiri lexicon data frame
#'
#' @param wlp_lexicon a Warlpiri lexicon data frame, or path to a Warlpiri dictionary file
#' @param groupings type of grouping(s) to append to the data frame (\code{"me_only"}, \code{"me_or_sse"}, or \code{c("me_or_sse", "se_or_sub")})
#'
#' @importFrom magrittr %<>%
#' @importFrom purrr partial
#' @importFrom tidylex add_group_col
#'
#' @export
#'

add_wlp_groups <- function(wlp_lexicon, groupings) {

    return_df <- make_wlp_df(wlp_lexicon)

    if(groupings[1] == "me_only") {

        return_df %<>%
            add_group_col(
                name  = me_start,
                where = code1 == "me",
                value = paste0(line, " : ", data)
            )

    } else if (groupings[1] == "me_or_sse") {

        return_df %<>%
            add_group_col(
                name  = me_or_sse_start,
                where = code1 %in% c("me", "sse"),
                value = paste0(line, " : ", data)
            )

    }

    if(!is.na(groupings[2]) && groupings[2] == "se_or_sub") {

        if(!groupings[1] == "me_or_sse") stop("First-level grouping needs to be 'me_or_sse' to add senses as a 2nd grouping.")

        return_df %<>%
            add_group_col(
                name  = se_or_sub_start,
                where = code1 %in% c("se", "sub"),
                value = paste0(line, " : ", data)
            )

    }

    return_df

}
