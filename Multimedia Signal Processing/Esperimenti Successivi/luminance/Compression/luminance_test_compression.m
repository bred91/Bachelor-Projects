close all; clear all; clc;

% Defining features space for training set
features_space_training = [];
features_space_test = [];

% Defining filter:
% - second derivative (vertical and horizontal)
% - quantization
f_v = [-1,2,-1];
f_h = f_v.';
h_o = [0,1,5,25,125];

% Select path for training set
selpath = uigetdir(pwd,'Choose folder for training set!');
cd (selpath);
training_image = dir('*.jpg');
for k = 1 : length(training_image)
    current_image = training_image(k).name;
    x = imread(current_image);
    features_vector_training = luminance_features_vector(x, f_v, f_h, h_o);
    features_space_training = cat(1,features_space_training, features_vector_training);
end

% Calculate PCA
N = length(training_image)/2;
[T, Xtrain_pca, average] = generate_pca(features_space_training, N);

% Calculate classificator Mdl
[Mdl, Y] = generate_mdl(Xtrain_pca);

% Select path for test set
selpath = uigetdir(pwd,'Choose folder for test set!');
cd (selpath);
test_image = dir('*.jpg');
for k = 1 : length(test_image)
    current_image = test_image(k).name;
    x = imread(current_image);
    imwrite(x,'nome.jpg','JPEG','Quality',70);
    x = imread('nome.jpg');
    features_vector_test = luminance_features_vector(x, f_v, f_h, h_o);
    features_space_test = cat(1,features_space_test, features_vector_test);
end

delete nome.jpg;

% Applicate PCA on features space test
Xtest_pca = (features_space_test - average) * T;

% Make prediction on test set based on Mdl
prediction = predict(Mdl,Xtest_pca);

% Z = tsne(PCA, 'Algorithm','exact', 'Distance', 'spearman');
% gscatter(Z(:,1),Z(:,2), A);
% 
% Z = tsne(PCA, 'Algorithm','exact', 'Distance', 'spearman', 'NumDimensions', 3);
% scatter3(Z(:,1),Z(:,2), Z(:,3), 20, A, 'filled');