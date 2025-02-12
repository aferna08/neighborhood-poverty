# Replication Package for Neighborhood Poverty by Nativity in the Top 100 Metro Areas (1970-2020)

This repository contains the replication package to create a visual analysis of neighborhood poverty rates by nativity within the top 100 CBSAs. The analysis shows what percent of foreign-born and US-born residents live in census tracts with different poverty rates over time. Please read the supplemental file for further methodological information, especially how geographic comparability is achieved.

I have included the necessary data in .zip format due to the large files sizes, but you will need to install Git LFS to download it.

------------------------------------------------------------------------

## Repository Structure

-   **`data/`**: Contains zipfiles of data necessary for the analysis. This includes shapefiles and population characterstics for census tracts and CBSAs.
-   **`output/`**: Where generated plots are stored.
-   **`scripts/`**: R Scripts to clean the data and create the visualizations.
    -   "01_clean_data.R" joins, cleans, and processes the census data.
    -   "02_graph.R" creates the final visualization, as well as two alternatives for the supplemental file.

------------------------------------------------------------------------

## How to Use

1.  **Clone the Repository**: Clone the repository, ensuring that Git LFS is installed.

    a)  You likely will be unable to open the .zip files if cloning from a web browser. Instead, run: `git clone https://github.com/aferna08/neighborhood-poverty destination_dir`. Input your own desired directory folder after installing Git LFS, and everything will run smoothly.

    b)  Alternatively, you can access the data directly from [NHGIS](https://www.nhgis.org/) and place it in the `data/` folder with the correct file names. Below are the necessary data files for each `.zip` file:

    -   **tract_shp.zip**: Contains Census Tract GIS files from 1970, 1980, 1990, 2000, 2012, and 2022.
    
    -   **cbsa_shp.zip**: Contains Core Based Statistical Area GIS files from 2022.
    
    -   **tract_data.zip**: A combined file of tract-level time series tables for nativity, persons below poverty level, and persons for whom poverty status is determined. This refers to tables AT5, CL6, and AX6, respectively.
    
    -   **cbsa_data.zip**: Contains CBSA-level population data for the 2018-2022 5-year ACS. This refers to table B01003.

2.  **Install Dependencies**: Scripts in the project use the [pacman](https://cran.r-project.org/web/packages/pacman/index.html) package (`install.packages("pacman")`) to install and load other required packages.

3.  **Reproduce the Visualization**: Run both scripts in order to produce the final visualizations.

------------------------------------------------------------------------

## Data Source

All data necessary for this project comes from the hard work of the NHGIS team. Any replications should cite them properly:

**Steven Manson, Jonathan Schroeder, David Van Riper, Katherine Knowles, Tracy Kugler, Finn Roberts, and Steven Ruggles. IPUMS National Historical Geographic Information System: Version 19.0 [dataset]. Minneapolis, MN: IPUMS. 2024. <http://doi.org/10.18128/D050.V19.0>**

------------------------------------------------------------------------

## Contact

If you have questions or would like to request the full working paper, please contact [aaronfernandez\@g.harvard.edu](mailto:aaronfernandez@g.harvard.edu).
