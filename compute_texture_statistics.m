function [comat_props_x, comat_props_y] = compute_texture_statistics(img, mask)
    img = img.*mask;

    comat_x = graycomatrix(img, 'NumLevels', 8, 'Offset', [0, 1]);
    comat_x(8, 8) = 0;
    comat_y = graycomatrix(img, 'NumLevels', 8, 'Offset', [1, 0]);
    comat_y(8, 8) = 0;

    comat_props_x = graycoprops(comat_x, 'all');
    comat_props_y = graycoprops(comat_y, 'all');
end