library(ellmer)
source("prompts.R")
items <- read.csv2("data/prompt_set.csv")

stopifnot(nrow(items) == 30)

stopifnot(all(c("id", "passage", "human_label") %in% names(items)))

stopifnot(nzchar(Sys.getenv("OPENAI_API_KEY")))

nrow(items)
names(items)
# Validate the input data before making API requests
stopifnot(!anyNA(items$id))
stopifnot(!anyDuplicated(items$id))
stopifnot(!anyNA(items$passage))
stopifnot(all(nzchar(trimws(as.character(items$passage)))))
stopifnot(!anyNA(items$human_label))
stopifnot(all(items$human_label %in% c("positive", "negative")))

message("Validation passed: 30 unique passages with valid labels.")
# Experiment configuration
model_name <- "gpt-4.1-mini"
output_file <- "data/my_runs.csv"

conditions <- c("generic", "operationalized")

# Create an empty results table
runs <- data.frame(
  id = character(),
  condition = character(),
  label = character(),
  model = character(),
  temperature = numeric(),
  top_p = numeric(),
  timestamp = character(),
  input_tokens = integer(),
  output_tokens = integer(),
  raw_response = character(),
  stringsAsFactors = FALSE
)

# Check the structure without making API calls
str(runs)
# Resume from previously saved results, if available
if (file.exists(output_file)) {
  runs <- read.csv(
    output_file,
    stringsAsFactors = FALSE,
    colClasses = c(id = "character")
  )
  message("Loaded ", nrow(runs), " previously saved classifications.")
} else {
  message("No previous results file found. Starting a new experiment.")
}

# Check for accidentally duplicated classifications
stopifnot(
  !anyDuplicated(paste(runs$id, runs$condition, sep = "::"))
)

# Show how many classifications are already saved
nrow(runs)
# Final checks before starting the experiment
stopifnot(nrow(items) == 30)
stopifnot(length(conditions) == 2)
stopifnot(identical(conditions, c("generic", "operationalized")))

# Check that previously saved results refer to valid passages and conditions
stopifnot(all(runs$id %in% as.character(items$id)))
stopifnot(all(runs$condition %in% conditions))

message("Final checks passed. Experiment is ready.")
# Run classifications and save each completed response
# Temporary limit for testing
max_new_calls <- 59
new_calls <- 0
for (condition in conditions) {
  
  current_prompt <- if (condition == "generic") {
    prompt_generic
  } else {
    prompt_operationalized
  }
  
  for (i in seq_len(nrow(items))) {
    
    passage_id <- as.character(items$id[i])
    
    # Skip classifications already saved
    already_done <- any(
      runs$id == passage_id &
        runs$condition == condition
    )
    
    if (already_done) {
      next
    }
    if (new_calls >= max_new_calls) {
      next
    }
    
    new_calls <- new_calls + 1
    
    # Create a fresh conversation for this classification
    chat <- chat_openai(model = model_name)
    
    result <- chat$chat_structured(
      paste0(
        current_prompt,
        "\n\nPassage to classify:\n",
        items$passage[i]
      ),
      type = type_answer
    )
    
    # Extract the original API response
    response <- chat$last_turn()@json
    
    # Create one results row
    new_row <- data.frame(
      id = passage_id,
      condition = condition,
      label = result$label,
      model = response$model,
      temperature = response$temperature,
      top_p = response$top_p,
      timestamp = as.character(
        as.POSIXct(response$created_at,
                   origin = "1970-01-01", tz = "UTC")
      ),
      input_tokens = response$usage$input_tokens,
      output_tokens = response$usage$output_tokens,
      raw_response = as.character(
        jsonlite::toJSON(
          response,
          auto_unbox = TRUE,
          null = "null"
        )
      ),
      stringsAsFactors = FALSE
    )
    
    # Add the result and immediately save the CSV
    runs <- rbind(runs, new_row)
    
    # Save results through a temporary file
    temporary_file <- paste0(output_file, ".tmp")
    
    write.csv(
      runs,
      temporary_file,
      row.names = FALSE
    )
    
    if (!file.rename(temporary_file, output_file)) {
      stop("Could not save results safely.")
    }
    
    message(
      "Saved ", nrow(runs), "/60: ",
      condition, " — passage ", passage_id
    )
  }
}

message("Experiment complete. Saved ", nrow(runs), " classifications.")