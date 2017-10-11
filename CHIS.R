#### Environment set up ####
  # Set working directory
  setwd("C:\\Users\\james.hooi\\Documents\\data analytics\\Springboard FDS exercises\\FDS-Ex4-CHIS")
  # Load source data, downloaded from https://www.datacamp.com/courses/data-visualization-with-ggplot2-2
  # Creates data frame: adult
  load(file = ".\\CHIS2009_reduced_2")

    
#### 1. Exploring the data ####
  # Explore the dataset with summary and str
  summary(adult)
  str(adult)
  
  # Age histogram (default)
  library(ggplot2)
  ggplot(adult, aes(x=SRAGE_P)) +
    geom_histogram()
  
  # BMI histogram (default)
  ggplot(adult, aes(x=BMI_P)) +
    geom_histogram()
  
  # Age colored by BMI - set binwidth to 1
  ggplot(adult, aes(x=SRAGE_P, fill=factor(RBMI))) +
    geom_histogram(binwidth=1)
  

#### 2. Cleaning the data ####
  # Remove individual aboves 84 - due to apparently all 85+ being classified as 85
  adult <- adult[adult$SRAGE_P <= 84, ]
  
  # Remove individuals with a BMI below 16 and above or equal to 52 - outliers
  adult <- adult[adult$BMI_P >= 16 & adult$BMI_P < 52, ]
  
  # Relabel the race variable:
  adult$RACEHPR2 <- factor(adult$RACEHPR2, labels = c("Latino","Asian","African American","White"))
  
  # Relabel the BMI categories variable:
  adult$RBMI <- factor(adult$RBMI, labels = c("Under-weight","Normal-weight","Over-weight","Obese"))
  

#### 3. Function: Merimeko/Mosaic Plot with Statistics and Text ####
  
  # Load all required packages
  library(ggplot2)
  library(reshape2)
  library(dplyr)
  library(ggthemes)
  
  # Script generalized into a function
  # Function creates a mosaic plot with three parameters
  # i. The data frame
  # ii. Which variable to use as x axis
  # iii. Which variable to use to colour segments by Chi-Sq residual
  mosaicGG <- function(data, X, FILL) {
  # Prepare table data from supplied parameters
    DF <- as.data.frame.matrix(table(data[[X]], data[[FILL]]))
  # Calculate the x and y coordinates of the rectangle extremes of each segment
    # Calculate xmax and xmin for each group
    DF$groupSum <- rowSums(DF)
    DF$xmax <- cumsum(DF$groupSum)
    DF$xmin <- DF$xmax - DF$groupSum
    DF$groupSum <- NULL
    # Use default row names in variable X so they can be referenced
    DF$X <- row.names(DF)
    # Reshape into long format
    DF_melted <- melt(DF, id = c("X", "xmin", "xmax"), variable.name = "FILL")
    # Calculate ymax and ymin
    DF_melted <- DF_melted %>%
      group_by(X) %>%
      mutate(ymax = cumsum(value/sum(value)),
             ymin = ymax - value/sum(value))
    
  # Perform Chi-squared test
    results <- chisq.test(table(data[[FILL]], data[[X]])) # fill and then x
    # Reshape into long format and identify variables consistent with DF_melted
    resid <- melt(results$residuals)
    names(resid) <- c("FILL", "X", "residual")
    
  # Merge data
    DF_all <- merge(DF_melted, resid)
    
  # Positions for labels
    # x axis: halfway between xmax and xmin of each segment
    DF_all$xtext <- DF_all$xmin + (DF_all$xmax - DF_all$xmin)/2
    # y axis: one label per FILL group at the right (max)
    index <- DF_all$xmax == max(DF_all$xmax)
    DF_all$ytext <- DF_all$ymin[index] + (DF_all$ymax[index] - DF_all$ymin[index])/2
    
  # Create mosaic plot
    # Base plot mapped to x and y coordinates, fill = residuals
    g <- ggplot(DF_all, aes(ymin = ymin,  ymax = ymax, xmin = xmin,
                            xmax = xmax, fill = residual)) +
      # Add white border on rectangles to make them easier to distinguish
      geom_rect(col = "white") +
      # Add text to x axis - effectively tick marks for each X
      geom_text(aes(x = xtext, label = X),
                y = 1, size = 3, angle = 90, hjust = 1, show.legend = FALSE) +
      # Add text to y axis - one for each FILL
      geom_text(aes(x = max(xmax),  y = ytext, label = FILL),
                size = 3, hjust = 1, show.legend = FALSE) +
      # Fill gradient for residuals per aes mapping (with default 2-color scale), label legend as "Residuals"
      scale_fill_gradient2("Residuals") +
      # Label x and y axes as "Individuals" and "Proportion" respectively
      # Place data adjacent to axes (no gap)
      scale_x_continuous("Individuals", expand = c(0,0)) +
      scale_y_continuous("Proportion", expand = c(0,0)) +
      # Apply Tufte theme for serif fonts
      theme_tufte() +
      # Move legend to bottom of screen
      theme(legend.position = "bottom")
    # Return the plot to the function call
    print(g)
  }
  
  
  
#### 4. Plot BMI described by Age ####
  # Call function with parameters
  mosaicGG(adult, "SRAGE_P", "RBMI")
  