library(httr2)
library(logger)
library(lubridate)
library(jsonlite)

log_info("🎯 Setting up request")
req <- request("https://newsapi.org/v2/everything") |>
req_url_query(
q = '`"paris"`',
from = Sys.Date() - 1,
pageSize = 10,
apiKey = Sys.getenv("NEWS_API_KEY")
)
log_info("⏳ Performing request...")
resp <- req_perform(req)
log_info("✅ Done!")
res <- resp_body_json(resp)
log_info("ℹ️ Request ended with status '{res$status}'")
log_info("ℹ️ Found {res$totalResults} articles")
log_info("ℹ️ Example article:")
log_info("{paste0(res$articles[[sample(seq_along(res$articles), 1)]], collapse = '\n')}")

log_info("📝 Writing file...")
if(!dir.exists("data")) dir.create("data")
path <- file.path("data", paste0(lubridate::today(), ".json"))
write_json(res, path = path)
log_info("✅ Done!")