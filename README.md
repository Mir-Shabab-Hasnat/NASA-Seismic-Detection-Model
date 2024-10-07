# Existential-Void-2024
NASA Space Apps Challenge 2024

# About
This repo is meant to store our project submission for the 2024 Nasa Space Apps Challenge. The challenge our team decided to tackle was Seismic Detection Across the Solar System. More info about the challenge can be found here: https://www.spaceappschallenge.org/nasa-space-apps-2024/challenges/seismic-detection-across-the-solar-system/

# Solution Overview
Our solution makes use of signal processing and machine learning to determine quakes within the given data. We use filtering on the data we were given, split that data into chunks, categorize those chunks to determine if they contain quakes by labelling them, and then feeding that categorized data into our ML model to train it. We then applied this model to test data to give us a trimmed output containing only the chunks with quakes in them.

# Solution Guide
Our main working file is WORKING_model2.ipynb. Within this Jupyter notebook you can see our entire process and collecting data and training our model, as well as sample output using a real test file. You can change the test file used by modifying the '''file_name''' and '''raw_data_dir''' variables within the code to view different tests.

