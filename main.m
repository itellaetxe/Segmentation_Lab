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
    "double", "double", "double", "double", "double", "double", "double", "double", ...
    "double", "double", "double", "double"];

varNames = ["Img", "Compactness", "Texture_contr_x", "Texture_corr_x", "Texture_energy_x", ...
    "Texture_homog_x", "Texture_contr_y", "Texture_corr_y", "Texture_energy_y", "Texture_homog_y", ...
    "Shape_mom1", "Shape_mom2", "Shape_mom3", "Shape_mom4", "Cont_sign_var", "Cont_sign_kurt", "Fourier_descr", ...
    "Skewness", "Kurtosis", "Smoothness", "Uniformity"];

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
    [~, df.Fourier_descr(imgN)] = fourier_descriptors(imcomplement(images{imgN}));

    % General texture statistics
    [df.Skewness(imgN), df.Kurtosis(imgN), ...
        df.Smoothness(imgN), df.Uniformity(imgN)] = ...
        compute_general_texture_stats(images{imgN}, tmp_mask);
end


%% SHAPE RECOGNITION USING CONTOUR SIGNATURE KURTOSIS AND RANGAYYAN'S NUMBER.
% If Rangayyan's number (ff) > 0.35 AND ContourSig. Kurtosis > 2.25 => TWO
% Otherwise, shape ==> ONE
% It works with and without noise.
figure;
scatter(df.Cont_sign_kurt, df.Fourier_descr, 'd', 'filled', 'MarkerFaceColor', 'red');
text(df.Cont_sign_kurt,df.Fourier_descr, df.Img);
xlabel('Contour signature kurtosis','FontSize', 16);
ylabel('Fourier descriptor','FontSize', 16);
title('Shape distinction', 'FontSize', 20);
ybars = [0.35 0.42];
hold on
patch([2.25 2.35 2.35 2.25], [ybars(1) ybars(1) ybars(2) ybars(2)],...
    [0.1 0.1 0.1],'EdgeColor', 'blue', 'FaceColor', 'none', 'LineWidth', 2);
hold off

%% TEXTURE RECOGNITION USING SKEWNESS AND UNIFORMITY (GENERAL STATISTICS)


% Decission tree:

% If Uniformity > 0.04 ==> PLAIN TEXTURE

% If Uniformity < 0.04 AND Skewness > 0.5 ==> WALLNUT
% If Uniformity < 0.04 AND Skewness < 0.5 ==> SKEWNESS

figure;
scatter(df.Uniformity, df.Skewness, 'd', 'filled', 'MarkerFaceColor', [128/256 0 128/256]); % purple is a nice color
text(df.Uniformity,df.Skewness, df.Img);
xlabel('Uniformity','FontSize', 16);
ylabel('Skewness','FontSize', 16);
title('Texture distinction', 'FontSize', 20);
set(gca, 'XScale', 'log') % Because in Uniformity plain from non plain differ a lot. This is to compact a bit the plot.

% Marble points (BLUE SQUARE)
xbars = [0.01 0.04];
ybars = [-2 0.5];
hold on
patch([xbars(1) xbars(2) xbars(2) xbars(1)], [ybars(1) ybars(1) ybars(2) ybars(2)],...
    [0.1 0.1 0.1],'EdgeColor', 'blue', 'FaceColor', 'none', 'LineWidth', 2);
hold off

% Wallnut points (RED SQUARE)
xbars = [0.01 0.04];
ybars = [0.5 3];
hold on
patch([xbars(1) xbars(2) xbars(2) xbars(1)], [ybars(1) ybars(1) ybars(2) ybars(2)],...
    [0.1 0.1 0.1],'EdgeColor', 'red', 'FaceColor', 'none', 'LineWidth', 2);
hold off

xline(0.04, '-', {'Plain texture'})