# R-script with some custom plotting functions
library(ggplot2)
library(dplyr)

# Define the function with the new 'top_n' parameter
# Default is 30, but you can set it to NULL to show all categories.
plot_col_freq <- function(data, col_name, top_n = 30) {
  
  # --- Data Preparation ---
  # 1. Create a frequency table and arrange by count
  # This gets all categories, sorted from most to least frequent
  full_df <- data[[col_name]] %>%
    table() %>%
    as.data.frame() %>%
    rename(Category = ".", Count = Freq) %>%
    arrange(desc(Count))
  
  # --- Filtering and Title Generation ---
  plot_df <- full_df
  plot_title <- paste("Frequency of", col_name)
  
  # 2. Check if we need to limit the number of categories to display
  # We apply the limit only if top_n is a number and is less than the total number of categories
  if (!is.null(top_n) && nrow(full_df) > top_n) {
    plot_df <- full_df %>%
      slice_head(n = top_n) # Keep only the top 'n' rows
    
    plot_title <- paste("Top", top_n, "Frequencies for", col_name)
  }
  
  # --- Plotting ---
  # 3. Set factor levels on the (potentially filtered) data frame to ensure correct order
  plot_df <- plot_df %>%
    mutate(Category = factor(Category, levels = Category))
  
  # 4. Create the ggplot object
  p <- ggplot(plot_df, aes(x = Category, y = Count)) +
    geom_bar(stat = "identity", fill = "steelblue", alpha = 0.9) +
    geom_text(aes(label = Count), vjust = -0.3, size = 3.5) + # Add count labels on top of bars
    labs(
      title = plot_title,
      subtitle = paste("Total unique categories:", nrow(full_df)),
      x = col_name,
      y = "Count"
    ) +
    theme_minimal(base_size = 12) +
    theme(
      axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),
      plot.title = element_text(face = "bold", size = 16),
      plot.subtitle = element_text(color = "gray40")
    )
  
  # 5. Return the plot
  return(p)
}

# Test code 
skip = TRUE
if(!skip){
  q = stx_query()
  plot_col_freq(q, "tax_genus")
  plot_col_freq(q, "tax_family")
  plot_col_freq(q, "measurement")
  plot_col_freq(q, "endpoint")
}

