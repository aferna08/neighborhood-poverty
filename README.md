# Replication Package for Neighborhood Poverty by Nativity in the Top 100 Metro Areas (1970-2020)

This repository contains the replication package to create a visual analysis of neighborhood poverty rates by nativity within the top 100 CBSAs. The analysis shows what percent of foreign-born and US-born residents live in census tracts with different poverty rates over time. Please read the supplemental file for further methodological information, especially how geographic comparability is achieved.

I have included the necessary data in .zip format due to the large files sizes, but you may still need Git LFS to download it.

# Repository Structure

-   **`data/`**: Contains zipfiles of data necessary for the analysis. This includes shapefiles and population characterstics for census tracts and CBSAs.
-   **`output/`**: Where generated plots are stored.
-   **`scripts/`**: R Scripts to clean the data and create the visualizations.
    -   "01_clean_data.R" joins, cleans, and processes the census data.
    -   "02_graph.R" creates the final visualization, as well as two alternatives for the supplemental file.

# How to Use

1.  **Clone the Repository**: Clone the repository, ensuring that Git LFS is installed.
2.  **Install Dependencies**: Scripts in the project use the [pacman](https://cran.r-project.org/web/packages/pacman/index.html) package (`install.packages("pacman")`) to install and load other required packages.
3.  **Reproduce the Visualization**: Run both scripts in order to produce the final visualizations.

# Contact

If you have questions or would like to request the full working paper, please contact [aaronfernandez\@g.harvard.edu](mailto:aaronfernandez@g.harvard.edu).
