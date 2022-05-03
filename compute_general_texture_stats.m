function [im_skew, im_kurts, im_smoo, im_unif] = compute_general_texture_stats(im, mask)
% Computes general texture statistics. Only applied in the image ROI.

[counts, bins] = imhist(im(mask));
counts = counts / sum(counts); % Probability counts

im_means = sum(counts .* bins);

im_vars = sum((bins - im_means).^2 .* counts);
im_m3 = sum((bins - im_means).^3 .* counts);
im_m4 = sum((bins - im_means).^4 .* counts);

im_skew = im_m3 / im_vars ^1.5;
im_kurts = im_m4 / im_vars ^2;

im_smoo = 1 - (1 + im_vars)^-1;
im_unif = sum(counts.^2);
end

