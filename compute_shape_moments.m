function moment = compute_shape_moments(mask, mom_num)
    %{
        Computes shape moment defined in mom_num. This function relays on
        compute_nu, which is the basic function to calculate shape moments.

        IN: Mask logical matrix, order of moment to be calculated
        OUT: Shape moment parameter
    %}

    switch mom_num
        case 1
            moment = compute_nu(mask, 2, 0) + compute_nu(mask, 0, 2);
        case 2
            tmp = compute_nu(mask, 2, 0) - compute_nu(mask, 0, 2);
            moment = tmp^2 + 4*compute_nu(mask, 1, 1)^2;
        case 3
            moment = (compute_nu(mask, 3, 0) - 3*compute_nu(mask, 1, 2))^2 + ...
                (3*compute_nu(mask, 2, 1) - compute_nu(mask, 0, 3))^2;
        case 4
            moment = (compute_nu(mask, 3, 0) + compute_nu(mask, 1, 2))^2 + ...
                (compute_nu(mask, 2, 1) + compute_nu(mask, 0, 3))^2;
        case 5
            disp("Must be implemented yet.")
            return;
        case 6
            disp("Must be implemented yet.")
            return;
        case 7 
            disp("Must be implemented yet.")
            return;
    end
    tmp = compute_nu(mask, 2, 0) - compute_nu(mask, 0, 2);
    moment2 = tmp^2 + 4*compute_nu(mask, 1, 1)^2;
    moment = moment/(moment2^(mom_num/2));
end

function nu = compute_nu(mask, ord_x, ord_y)

    % Compute centroid of the binary shape
    stats = regionprops(mask);
    centroid = stats.Centroid;

    % Save coordinates of the pixels == 1
    [x, y] = find(mask==1);
    
    % Computing distance from every pixel to the centroid
    nu = sum(((x-centroid(1)).^ord_x).*((y-centroid(2)).^ord_y), 'all');
end