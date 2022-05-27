# environmental_monitoring_dashboard
A shiny app to visualize environmental monitoring data in a ISO classified pharmaceutical manufacturing facility

SUMMARY
August Bioservices is a startup specializing in Phase III clinical trials and commercial drug manufacturing. Part of my duties involve environmental monitoring of the manufacturing facility and analysis of that data. That data includes counts of both viable and non-viable particles in classified areas of a controlled facility. ISO classification number at August Bio includes ISO classes 5 through 8. The lower the number of the classification, the less particles you should detect, whether viable or non-viable. Viable, meaning they form bacterial or fungal colonies on a petri dish. That data is tracked over time and new microbes that appear have to be identified and their source determined.
As an example of why this is important, in 2012 the New England Compounding Facility was shut down after one of their compounded drugs (methylprednisolone) contributed to an outbreak of fungal meningitis resulting in over 100 deaths. This incident is a case study in why environmental monitoring in a pharmaceutical manufacturing facility is important. Many of these regulations are written in blood. 14 former employees of NECC were charged federally, and 11 individuals were convicted and sentenced to prison sentences as long as 9 years. h"ps://en.wikipedia.org/wiki/ New_England_Compounding_Center_meningi:s_outbreak

Tennessee had the first reported case of fungal meningitis from the NECC outbreak. Facilities like August Bioservices are regulated by the FDA to maintain records of our cleaning procedures, disinfectants, and any microbes we detect in our facility. I was recently transferred as part of a reorganization to the microbiology department at August and I thought this would also be a great opportunity to showcase the new skills I’ve learned at Nashville Software School.

PURPOSE

ISO 14644 is a standard set by the International Organization for Standardization. It’s the guiding document we use to classify our cleanroom facilities and is an acceptable standard per FDA 21 CFR part 11 which regulates drug manufacturing facilities in the United States.

ISO 14644 sets out alert and action levels for when a cleanroom is out of specification for its ISO Class. https://www.linkedin.com/pulse/understanding-cleanroom-classifications-iso-8-7-6-5- charles-lipeles/
During an FDA inspection/audit, the auditors will want to see documentation for the facilities cleaning schedule, disinfectants, any environmental isolates collected from the classified cleanrooms.
Using the data that I collect, can I predict when additional cleaning is necessary outside of the usual cleaning routine as is the case when we approach an Alert level? Also, will it make accessing this data much easier during an FDA inspection/audit?

MVP:

A Shiny app or googlesite that displays a map of the facility. When you hover over monitoring sites, it shows you aggregate data for that site along with trend lines from the current counts.
I have maps of the old facility that I want to create buttons that when you click, a graph pops up so you can see the trending for that site.

SCHEDULE:
Schedule (through 6/16/2022)
1. Get the Data (COMPLETE sort of.)
2. Clean & Explore the Data (6/2/2022)
  2.a. Figure out how to Import the floorplan with a CRS -- Done I think.
  2.b. Pivot data for site locations
  2.c. Do some EDA for trending data. Add annotations for limits
  2.d. Add buttons to sampling sites to take you to trending data for site
  2.e. ???
3. Create Presentation (6/7/2022)
4. Internal Demos (6/11/2022)
5. Demo Day (6/16/2022)

DATA SOURCES:
Historical environmental monitoring data of our old facility. The new facility is currently under construction.

ISSUES:
The new facility is currently under construction so existing monitoring data does not exist. So this will be a snapshot for an old facility but it should be a simple task to import the new site maps and recode the locations.
The data itself is not particularly large but it is dirty. It contains many strings that describe bacteria/fungal colonies, +/- for growth, raw counts, NAs. It will need a lot of cleaning for it to be usable. Part of my goal with this project is to automate this process so it’s more standardized. Data integrity is part of the requirements of the FDA regulations.
There’s also a lot of technical jargon I’ll have to explain when presenting this. I’ll need to simplify it for a non-technical audience and force myself to not use technical language during the presentation.

5/24/2022
Goal: Get the floorplan into something that has a CRS.
Result: Was able to import the png and add to a map with CRS. if you zoom out you see Africa. I'll need to set a max and min zoom level and annotate to get the site locations as buttons some how.

5/26/2022
Goal: Perform some EDA. I need to at least get some pivot tables working for the data to be usable.
MID number needs to be pivoted and counted and grouped with the site locations.

Results: Noticed an error on import where a merged cell across two rows resulted in NAs in the MID Number column. Solved.

Pivoted longer: Used pivot_longer(cols = starts_with('Site Location'), values_drop_na = TRUE) and got the output I was looking for. Dropped the unnecessary columns and renamed them.

I'll need to figure out how to group by the sample site and date, and count the number of ID's this way to make the graphs I want to show up when clicking on a sample site. 
