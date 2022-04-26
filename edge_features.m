function [contourSig] = edge_features(im)
% EDGE_FEATURES: gives you the contour signature of the image, xlocs and
% ylocs. Follows contour in order. 
% INPUT IMAGE ALREADY WITH BLACK BCKG.

% Edge mask (boundaries)
[~, dROI] = segment_element(im);
% Centroid
centroid = regionprops(dROI, 'Centroid');

%%% BWBOUNDARIES IMPLEMENTATION
[points, ~] = bwboundaries(dROI);
points = points{1};
contourSig = sqrt((points(:,1)-centroid.Centroid(:,1)).^2 + (points(:,2)-centroid.Centroid(:,2)).^2);


%%% MY IMPLEMENTATION, DID NOT WORK WELL
% canv_n = dROI;
% [Y, X] = find(dROI, 1);
% pointx = X; pointy = Y;
% xlocs = zeros(1,sum(dROI(:))); ylocs = xlocs;
% contourSig = xlocs;
% ci = 1;
% 
% % Pattern to delete unique
% patt = -ones(3); patt(2,2) = 1;
% while (1)
%     canv_n(pointy, pointx) = 0;
%     p = find(canv_n(pointy-1:pointy+1, pointx-1:pointx+1));
%     if isempty(p)
%         break;
%     end
%     p = p(1);
% 
%     switch p
%         case 1
%             pointy = pointy - 1;
%             pointx = pointx - 1;
%         case 2
%             pointx = pointx - 1;
%         case 3
%             pointy = pointy + 1;
%             pointx = pointx - 1;
%         case 4
%             pointy = pointy - 1;
%         case 6
%             pointy = pointy + 1;
%         case 7
%             pointy = pointy - 1;
%             pointx = pointx + 1;
%         case 8
%             pointx = pointx + 1;
%         case 9
%             pointy = pointy + 1;
%             pointx = pointx + 1;
%     end
%     xlocs(ci) = pointx;
%     ylocs(ci) = pointy;
%     contourSig(ci) = sqrt((pointx-xm).^2 + (pointy-ym).^2);
%     canv_n = xor(canv_n, bwhitmiss(canv_n, patt));
%     if ci == 700
%         pause(0.01);
%     end
% 
%     ci = ci + 1;
% end
% disp('a')
end

