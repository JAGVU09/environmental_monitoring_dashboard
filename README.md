#environmental_monitoring_dashboard
A shiny app to visualize environmental monitoring data in a ISO classified pharmaceutical manufacturing facility

SUMMARY
High tech manufacturing requires cleanrooms to maintain sterility and/or low concentrations of airborne particles. Data is collected at sampling sites dictated by ISO14644. That data includes counts of both viable and non-viable particles in classified areas of a controlled facility. ISO classification numbers typicall include ISO classes 5 through 8. The lower the number of the classification, the less particles you should detect, whether viable or non-viable. Viable, meaning they form bacterial or fungal colonies on a petri dish. That data is tracked over time and new microbes that appear have to be identified and their source determined.

As an example of why this is important, in 2012 the New England Compounding Facility was shut down after one of their compounded drugs (methylprednisolone) contributed to an outbreak of fungal meningitis resulting in over 100 deaths. This incident is a case study in why environmental monitoring in a pharmaceutical manufacturing facility is important. Many of these regulations are written in blood. 14 former employees of NECC were charged federally, and 11 individuals were convicted and sentenced to prison sentences as long as 14.5 years.https://en.wikipedia.org/wiki/New_England_Compounding_Center_meningitis_outbreak

Tennessee had the first reported case of fungal meningitis from the NECC outbreak. Facilities like August Bioservices are regulated by the FDA to maintain records of our cleaning procedures, disinfectants, and any microbes we detect in our facility. I was recently transferred as part of a reorganization to the microbiology department at August and I thought this would also be a great opportunity to showcase the new skills I’ve learned at Nashville Software School.

PURPOSE
To visualize environmental monitoring data easily and predict trends from past data.

ISO 14644 is a standard set by the International Organization for Standardization. It’s the guiding document we use to classify our cleanroom facilities and is an acceptable standard per FDA 21 CFR part 11 which regulates drug manufacturing facilities in the United States.

ISO 14644 sets out alert and action levels for when a cleanroom is out of specification for its ISO Class. https://www.linkedin.com/pulse/understanding-cleanroom-classifications-iso-8-7-6-5-charles-lipeles/
During an FDA inspection/audit, the auditors will want to see documentation for the facilities cleaning schedule, disinfectants, any environmental isolates collected from the classified cleanrooms.
Using the data that I collect, can I predict when additional cleaning is necessary outside of the usual cleaning routine as is the case when we approach an Alert level? Also, will it make accessing this data much easier during an FDA inspection/audit?

MVP:

A Shiny app that displays a map of the facility. When you click on monitoring sites, it shows you aggregate data for that site along with predictive forecasting using ARIMA models.



DATA SOURCES:
Historical environmental monitoring data of our old facility.
