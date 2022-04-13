function [skeleton] = do_thinning(im)
%EXTRACT_SKELETON: Extracts skeleton. Nothing strange.
%   As done in the morphological operations practice.

element = [-1, -1, -1; 
           0, 1, 0;
           1, 1, 1];
Xk = [];
Xk_n = im;
while ~isequal(Xk, Xk_n)
    Xk = Xk_n;
    for i = 1:8
        Xk_n = xor(Xk_n, bwhitmiss(Xk_n, imrotate(element, 360/8*i, 'crop')));
    end
end
skeleton = Xk;
% clear; clc; close all
% path = "./Segmentation_Classification_Lab/";
% fname = "2d.png";
% im = im2double(rgb2gray(imread(path+fname)));
% im = imcomplement(im);