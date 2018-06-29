#' Add grouping columns to a Warlpiri lexicon data frame
#'
#' @param wlp_df a Warlpiri lexicon data frame
#' @param groupings type of grouping(s) to append to the data frame
#'
#' @importFrom magrittr %<>%
#' @importFrom purrr partial
#' @importFrom tidylex add_group_col
#'
#' @export
#'

add_wlp_groups <- function(wlp_df, groupings) {

    return_df <- wlp_df

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
