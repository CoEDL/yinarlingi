library(base64enc)
library(gmailr)
library(stringr)

# Configure authentication from variables data stored in GitLab
tmpfiles <- tempfile(fileext = c(".txt", ".txt"))

Sys.getenv("GMAIL_OAUTH") %>% writeLines(tmpfiles[1])
base64decode(file = tmpfiles[1], output = ".httr-oauth")

Sys.getenv("GMAIL_SECRET") %>% writeLines(tmpfiles[2])
base64decode(file = tmpfiles[2], output = "warlpiri-dictionary.json")
use_secret_file(filename = "warlpiri-dictionary.json")

# Get deploy information from Netlify output
text_msg <- readLines("tmp/netlify-deploy-info.txt") %>%
    .[c(-1,-2)] %>%
    paste0(collapse = '\n') %>%
    str_replace("Deploy is live",
                paste("Test suite ran on", Sys.getenv("CI_COMMIT_SHA"), "triggered by", Sys.getenv("GITLAB_USER_NAME"))
                ) %>%
    str_replace("Last build is", "Latest test results are") %>%
    as.character()

cat(text_msg)

mime() %>%
    to(Sys.getenv("GITLAB_USER_EMAIL")) %>%
    from(Sys.getenv("GMAIL_SENDER")) %>%
    subject(paste0("Warlpiri dictionary tests: ", readLines("tmp/tests_status.txt"))) %>%
    text_body(text_msg) %>%
    send_message()
