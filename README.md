# Traffic Sign Detection and Recognition with MATLAB

## Report
See TSDR_En.pdf for a complete overview of the project.

## Overview
This repository contains MATLAB code for a traffic sign and shape recognition system. The project is organized into three main pipelines:

1. **Inference Pipeline (main_pipeline.m):**  
   Loads a test image and pre-trained models (SVM and Random Forest), performs image segmentation, extracts regions of interest (ROIs), classifies shapes using SVM, and then classifies traffic signs using a Random Forest classifier. Results and visualizations are displayed.

2. **Random Forest Training Pipeline:**  
   Located in the `RF_Model/` folder, this pipeline loads the training data from CSV files, performs feature extraction and dataset balancing, trains a Random Forest classifier (with early stopping), evaluates its performance, and saves the trained model (`modelloRF.mat`) in the parent folder of the current directory. The main training script is `main_train.m`.

3. **SVM Training Pipeline:**  
   Located in the `Shape_Classifier_SVM/` folder, this pipeline processes a large dataset of images by performing preprocessing, feature extraction, and splitting into training/test sets. It uses grid search with k-fold cross-validation to tune SVM hyperparameters, trains the SVM model, evaluates its performance, and saves the trained model (`modelloSVM.mat`). The main training script is `main_train.m`.

## Repository Structure
```
├── main_pipeline.m           % Inference pipeline: processes a test image and performs classification using pre-trained models.
├── Shape_Classifier_SVM/     % Folder for SVM training pipeline.
│   └── main_train.m          % Main script for training the SVM classifier.
├── RF_Model/                 % Folder for Random Forest training pipeline.
│   └── main_train.m          % Main script for training the Random Forest classifier.
├── TestImages/               % Folder for test images (e.g., test1.png).
├── data/                    
│   ├── raw/                 % Raw data: CSV files (Train.csv, Test.csv, Meta.csv) and meta images.
│   └── processed/           % Processed data and results.
└── README.md                % This file.
```



### 1. Inference Pipeline (`main_pipeline.m`)
- **Purpose:**  
  Processes a test image by performing color segmentation (RGB to HSI conversion), mask creation/cleaning, ROI extraction, shape classification (via SVM), and traffic sign classification (via Random Forest).

- **Usage:**  
  Open MATLAB, navigate to the repository root, and run:
  ```matlab
  main_pipeline.m
  ```

- **Output:**  
  - Displays the original image, segmentation results, detected ROIs, and classification outcomes (including bounding boxes, labels, and scores).  
  - Generates visualizations such as a montage of ROIs and confusion charts.  
  - Prints a final report with classification details to the command window.

---

### 2. Random Forest Training Pipeline (`RF_Model/main_train.m`)
- **Purpose:**  
  Loads the training dataset, extracts features, balances the dataset, trains a Random Forest classifier (with early stopping), evaluates its performance, and saves the model as `modelloRF.mat` (in the parent directory).

- **Usage:**  
  Navigate to the `RF_Model/` folder in MATLAB and run:
  ```matlab
  main_train.m
  ```

- **Output:**  
  - Displays training progress and evaluation metrics (e.g., training time, optimal number of trees).  
  - Saves the trained model in the parent folder under the name `modelloRF.mat`.

---

### 3. SVM Training Pipeline (`Shape_Classifier_SVM/main_train.m`)
- **Purpose:**  
  Processes a large dataset of images by performing preprocessing, feature extraction, and splitting into training/test sets. Uses grid search with k-fold cross-validation to determine the best SVM hyperparameters, trains the SVM model, evaluates its performance, and saves the model as `modelloSVM.mat`.

- **Usage:**  
  Navigate to the `Shape_Classifier_SVM/` folder in MATLAB and run:
  ```matlab
  main_train.m
  ```

- **Output:**  
  - Displays the performance of various parameter combinations and the best-found parameters.  
  - Prints evaluation metrics (e.g., accuracy, F1-score) and generates confusion charts.  
  - Saves the trained model as `modelloSVM.mat` in the current directory.

---

## Output and Results
- **Inference Pipeline:**  
  Provides visual feedback including the original image, processed masks, detected ROIs, and final classification with bounding boxes and labels.

- **Training Pipelines:**  
  Display training progress and evaluation metrics. The trained models are saved for future inference.

---

## Data Disclaimer
- **Test Images:** Not included. Please provide your own images in the `TestImages/` folder.
- **Pre-trained Models:** Not included. If you do not have pre-trained models, train them using the respective training pipelines.
- **Dataset Files**: The dataset used is the GTSRB (German Traffic Sign Recognition Benchmark). Download the dataset from Kaggle, extract it, and copy the necessary CSV files and meta images into the data/raw/ folder.

---

## Contact
For questions or further support, please contact:  
Riccardo Roscica  
[riccardoroscica@gmail.com](mailto:riccardoroscica@gmail.com)
