###### Anthony J. Gertz
###### Nashville Software School
###### Data Science Cohort 4
###### Final Project

# Exploration of Variance in Neural Network Training
<br>
<br>


## Data Question
How widely does Neural Network training randomize model fitting over repeated iterations and across the same data? 
<br>


## Learning Objectives
1.)	EDA honing with non-class sanctioned data,
2.)	ML Code & Script Automation, <br>
3.)    TensorFlow & Keras v2.5, <br>	
4.)    Multi-GPU Strategies (tf.distributed), <br>
4.)    Linux/Unix Environment Command Line Interface, <br>
5.)    Remote Coding Environments, <br>
6.)    Docker Container Environment <br>
<br>


## Data
F-16 Ground Vibration Benchmark Test
- Provides 20 linear and non-linear datasets of over 100,000 records each <br>
- F16Data_SineSW_Level3 <br>
- https://sites.google.com/view/nonlinear-benchmark/benchmarks/f-16-gvt?authuser=0 <br>


## Training Summary
Total Models Trained: 6000 (500 per model parameter set)<br>
<br>
Total Time Training: 336 Hours, 23 Minutes, 29 seconds<br>
Average Time Training: 3 minutes, 22 seconds <br>
<br>
Total Epochs: 281,838<br>
Average Epochs Per Model: 46.97<br>
<br>


## Model Parameters
Model: Sequential<br>
Regression: Linear<br>
Training iterations: 500<br>
Test Size = 0.20<br>
ES Test Size = 0.25<br>
Patience = 25<br>
Layers = 2/4/6<br>
Density = 64/128<br>
Activation = relu/leakyrelu<br>
Loss = Mean Squared Error<br>
Optimizer = Adam<br>
Batch Size = 64<br>
Epochs = 250<br>


## Variance in Epochs Across Density

![Image](epochs_density.png)

## Variance in Epochs Across Activation

![Image2](epochs_activation.png)

## Variance in MAE Across Density

![Image3](mae_density.png)

## Variance in MAE Across Activation

![Image4](mae_activation.png)


### Primary Software Platforms: 
Ubuntu Bionic v18.04 <br>
Python 3.9.5 <br>
TensorFlow v2.5 <br>
Docker CE v20.1 <br>
NVIDIA Docker Container Toolkit<br>


