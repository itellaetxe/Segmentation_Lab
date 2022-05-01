%% Check for all images

close all;
clear;
clc;
rng('default');

% Search for images in our directory
imagefiles = dir('./Segmentation_Classification_Lab/*.png');      
nfiles = length(imagefiles); % Number of images found

% Ask if noise should be added to the images or not
noiseCheck = string(input("Do you want to add noise to the images [y/n]? ", 's'));

for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   currentimage = imread("./Segmentation_Classification_Lab/" + currentfilename);
   if strcmp(noiseCheck, "y") == 1
       images{ii} = im2double(rgb2gray(currentimage)) + randn([400, 400]).*.02;
   elseif strcmp(noiseCheck, "n") == 1
       images{ii} = im2double(rgb2gray(currentimage));
   else
       disp("Not a valid response. Try again.");
       break;
   end
end

%% Creating a table and storing the information for each image

varTypes = ["string", "double", "double", "double", "double", "double", "double", "double", "double", ...
    "double", "double", "double", "double", "double", "double", "double", "double"];

varNames = ["Img", "Compactness", "Texture_contr_x", "Texture_corr_x", "Texture_energy_x", ...
    "Texture_homog_x", "Texture_contr_y", "Texture_corr_y", "Texture_energy_y", "Texture_homog_y", ...
    "Shape_mom1", "Shape_mom2", "Shape_mom3", "Shape_mom4", "Cont_sign_var", "Cont_sign_kurt", "Fourier_descr"];

% Dataframe creation
df = table('Size', [nfiles, length(varNames)], 'VariableTypes', varTypes, 'VariableNames', varNames);

% Introducing calculated parameters into the df for each image
for imgN = 1:nfiles

    % First column will be used to identify each image
    df.Img(imgN) = imagefiles(imgN).name;

    % Obtention of the mask and the boundary of the original image (number)
    [tmp_mask, tmp_bound] = segment_element(imcomplement(images{imgN}));

    % Compactness parameter
    df.Compactness(imgN) = compute_compactness(tmp_bound, tmp_mask);

    %{
        The compactness is able to distinguish between equal shapes, but it
        is not enough for us to be able to identify the ones and the twos.
        E. g.: 1W.png and 1p.png are written in the same letter style (same
        shape).
    %}
    
    % Texture parameters using co-occurrence matrixes
    [text_stat_x, text_stat_y] = compute_texture_statistics(images{imgN}, tmp_mask);

    df.Texture_contr_x(imgN) = text_stat_x.Contrast;
    df.Texture_corr_x(imgN) = text_stat_x.Correlation;
    df.Texture_energy_x(imgN) = text_stat_x.Energy;
    df.Texture_homog_x(imgN) = text_stat_x.Homogeneity;

    df.Texture_contr_y(imgN) = text_stat_y.Contrast;
    df.Texture_corr_y(imgN) = text_stat_y.Correlation;
    df.Texture_energy_y(imgN) = text_stat_y.Energy;
    df.Texture_homog_y(imgN) = text_stat_y.Homogeneity;

    % Shape moments
    df.Shape_mom1(imgN) = compute_shape_moments(tmp_mask, 1);
    df.Shape_mom2(imgN) = compute_shape_moments(tmp_mask, 2);
    df.Shape_mom3(imgN) = compute_shape_moments(tmp_mask, 3);
    df.Shape_mom4(imgN) = compute_shape_moments(tmp_mask, 4);

    % Calculus of the contour signature and extraction of parameters
    [contourSig, ~, ~] = edge_features(imcomplement(images{imgN}));
    df.Cont_sign_var(imgN) = std(contourSig);
    df.Cont_sign_kurt(imgN) = kurtosis(contourSig);

    % Calculus of Rangayyan's number 
    [~, df.Fourier_descr(imgN)] = fourier_descriptors(images{imgN});
end

stackedplot(df);

figure;
scatter3(df.Cont_sign_kurt,df.Shape_mom3, df.Fourier_descr, 'd', 'filled', 'MarkerFaceColor', 'red');
text(df.Cont_sign_kurt,df.Shape_mom3,df.Fourier_descr, df.Img);
xlabel('Contour signature kurtosis','FontSize', 16);
ylabel('3rd shape moment','FontSize', 16);
zlabel('Fourier descriptor','FontSize', 16);
title('Clustering function obtention', 'FontSize', 20);