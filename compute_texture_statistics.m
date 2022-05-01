function [comat_props_x, comat_props_y] = compute_texture_statistics(img, mask)
    %{
        Computes texture statistical parameters using co-occurrence matrixes.

        IN: Image matrix, mask logical matrix
        OUT: Property struct with Energy, Correlation, Homogeneity and
        Contrast parameters.
    %}

    img = imcomplement(img);
    img = imgaussfilt(img, .5, 'FilterSize', [5, 5]);
    img = img.*mask;

    comat_x = graycomatrix(img, 'NumLevels', 8, 'Offset', [0, 1]);
    comat_x(1, 1) = 0;
    comat_y = graycomatrix(img, 'NumLevels', 8, 'Offset', [1, 0]);
    comat_y(1, 1) = 0;

    comat_props_x = graycoprops(comat_x, 'all');
    comat_props_y = graycoprops(comat_y, 'all');
end