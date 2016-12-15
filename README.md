This is the code used for [the paper](https://arxiv.org/abs/1608.04674) "Shape Constrained Tensor Decompositions using
Sparse Representations in Over-Complete Libraries" by Bethany Lusch, Eric C. Chi, and J. Nathan Kutz.

We develop a data decomposition method called Shape Constrained Tensor Decomposition (SCTD). The data is decomposed so that the time dimension is represented as a sparse linear combination of elements from an over-complete library. This provides interpretability and an analytic form. This method is designed to avoid needing to flatten the data into a matrix and to be able to extract transient and intermittent phenomena. For more information, see the paper. 

This code is primarily written in Matlab, although we use R to set up one example dataset. It is posted so that you can recreate our results, but you can also use it to decompose your own data. 

OurMethod/BaseExperiment.m contains the main function for testing our algorithm. It has many parameters so that everything can be varied. The files that begin with "Experiment" are scripts that call BaseExperiment. They load default parameters from BaseParams.mat and change whichever parameters are different for that experiment. See SetBaseParams.m to see how BaseParams.mat is created. 

This code uses the [Matlab Tensor Toolbox](http://www.sandia.gov/~tgkolda/TensorToolbox/index-2.6.html) produced by Sandia.



To try this method on your own data, save your data as a variable called X in a .mat file and pass the filename to BaseExperiment as the input "dataname." The current code expects three-dimensional data where the third dimension is time. It is also important to choose a good library for your example. The input "dictfn" should be a function that creates the library/dictionary. The input to this function should be the number of prototypes desired in the library, and the output should be the library, the number of prototypes, and the parameters of the prototypes. The OurMethod folder contains all of the functions we used to create libraries for this paper.



To recreate our results, check out the DMD and data folders:

The DMD folder contains an implementation of Dynamic Mode Decomposition, which we use in the paper for comparison.

The data folder contains code for setting up the example datasets from the paper. VideoExampleData.m creates the simulated dataset used in Section IV. 

The R script saveCrimeTensor.R uses the crime dataset provided in the R package ggmap. This data was collected by the Houston Police Department in 2010. We describe it further in section V.A. of our paper. We use Houston_Police_Beats.csv to reorder the beats to make them easier to map later. We obtained this csv file from the Houston Police Beats page of the [City of Houston GIS Open Data web site] (http://cohgis.mycity.opendata.arcgis.com/datasets/fb3bb02ec56c4bb4b9d0cf3b8b3e5545_4?uiTab=table&geometry=-96.701%2C29.619%2C-94.087%2C29.977). We save the subset of crime data that we are interested in as csv files. Then we use saveCrimeTensor.m to load these csv files, create a tensor, and save it as a .mat file for use in experiments. 

The script prepareNOAAdata.m does some preprocessing to a dataset of ocean surface temperatures downloaded from [NOAA's website](http://www.esrl.noaa.gov/psd/). We specifically used the NOAA_OI_SST_V2 dataset. We use this example in Section V.B. of our paper. 
