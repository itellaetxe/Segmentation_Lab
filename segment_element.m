function [mask, bound] = segment_element(img)
    %{
        Computes mask and boundary of the image that is inserted.

        IN: image matrix
        OUT: logical mask matrix, logical boundary matrix
    %}

    curr = imclose(img, ones(5));

    % Otsu
    thr = graythresh(curr);
    curr = curr > thr;

    curr = imclose(curr, ones(7));

    element = -ones(3);
    element(2,2) = 1;
    hits = bwhitmiss(curr, element);

    mask = xor(curr, hits);
    bound = bwmorph(mask, 'remove');
end