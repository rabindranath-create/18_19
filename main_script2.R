# main_script.R


# Make sure working directory is the same as the script location (implicitly handled in GitHub Actions)
# Print working directory
cat("Working directory:", getwd(), "\n")

# Set up and confirm output folder
output_dir <- file.path(getwd(), "outputs/script2")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
cat("Created directory:", output_dir, "\n")

# Confirm contents before saving
print("Files in 'outputs' before saving:")
print(list.files("outputs", recursive = TRUE))

# Save dummy test file just to verify
writeLines("test", file.path(output_dir, "test.txt"))




# Load the helper script
source("RD_and_DT_Algorithm_copy.R")  # Ensure this file is in the same directory

lambda <- 2


results_1 <- data.frame(
  Run = integer(),
  N_t = integer(),
  K = integer(),
  Length = numeric(),
  Cost = numeric(),
  NumDisambigs = integer()
)

cost <- 5

for (i in 1:100) {
  for (j in 0:6){
  obs_gen_para <- c(gamma = 0.3, d = 5, noPoints = 75, no_c = 50, no_o = 25)
  result <- ACS_Alg_M(obs_gen_para, kei = j, lambda, cost)
  
  results_1[7*(i-1) + j + 1, ] <- list(
    Run = 7*(i-1) + j + 1,
    N_t = 25,
    K = j,
    Length = result$Length_total,
    Cost = result$Cost_total,
    NumDisambigs = length(result$Disambiguate_state)
    )
  }
}

saveRDS(results_1, file.path(output_dir, "data_25_1_1.rds"))







results_2 <- data.frame(
  Run = integer(),
  N_t = integer(),
  K = integer(),
  Length = numeric(),
  Cost = numeric(),
  NumDisambigs = integer()
)


for (i in 1:100) {
  for (j in 0:6){
  obs_gen_para <- c(gamma = 0.3, d = 5, noPoints = 100, no_c = 50, no_o = 50)
  result <- ACS_Alg_M(obs_gen_para, kei = j, lambda, cost)
  
  results_2[7*(i-1) + j + 1, ] <- list(
    Run = 7*(i-1) + j + 1,
    N_t = 50,
    K = j,
    Length = result$Length_total,
    Cost = result$Cost_total,
    NumDisambigs = length(result$Disambiguate_state)
    )
  }
}

saveRDS(results_2, file.path(output_dir, "data_25_1_2.rds"))








# Combine all results into one table
results <- rbind(results_1, results_2)

# Format output
results_out <- data.frame(
  Index = paste0('"', 1:nrow(results), '"'),  # Quoted index
  results[, c("N_t", "K", "Length", "Cost", "NumDisambigs")]  # Make sure column names match
)

# Define the custom header (space-separated, quoted)
header <- '"n_t" "k" "length" "cost" "number_of_disambiguations"'

# Define output path
txt_path <- file.path(output_dir, "results_ACS1_mixed.txt")

# Write header manually
writeLines(header, txt_path)

# Append data
write.table(
  results_out,
  file = txt_path,
  append = TRUE,
  row.names = FALSE,
  col.names = FALSE,
  quote = FALSE,
  sep = " "
)

cat("✅ Text results saved to:", txt_path, "\n")
