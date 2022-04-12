function [mask, bound] = segment_element(img)

    curr = imclose(img, ones(5));
    thr = graythresh(curr);

    curr = curr > thr;
    curr = imclose(curr, ones(7));

    element = -ones(3);
    element(2,2) = 1;
    hits = bwhitmiss(curr, element);
    mask = xor(curr, hits);
    bound = bwmorph(mask, 'remove');
end