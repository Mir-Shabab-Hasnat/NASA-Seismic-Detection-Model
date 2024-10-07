# Existential-Void-2024
NASA Space Apps Challenge 2024

# About
This repo is meant to store our project submission for the 2024 Nasa Space Apps Challenge. The challenge our team decided to tackle was Seismic Detection Across the Solar System. More info about the challenge can be found here: https://www.spaceappschallenge.org/nasa-space-apps-2024/challenges/seismic-detection-across-the-solar-system/

# Solution Overview
Our solution makes use of signal processing and machine learning to determine quakes within the given data. We use filtering on the data we were given, split that data into chunks, categorize those chunks to determine if they contain quakes by labelling them, and then feeding that categorized data into our ML model to train it. We then applied this model to test data to give us a trimmed output containing only the chunks with quakes in them.

Our team was able to develop an algorithm to transform NASA’s seismic space data and use it to train an AI model in such a way that it is now able to predict exactly which chunks of the data contain seismic activity During our training, from within around 11.73 million data points, the model was able to identify the 300,000 useful data points successfully. 

This means that if implemented, our model can send the necessary 2.6% of the data currently being sent by NASA to earth, which is a HUGEEEE efficiency and cost improvement.

# Solution Guide
Navigate to the main folder and enter into the model.ipynb file. You can inter the the raw test file info you want to test, and you can get the names and firectories for these files in the data folder. You can tweek the settings if you like but I would suggest do not. Run the model.ipynb file and wait scroll down to the bottom to see the results

