%Display the OF as a plot of vectors
function display_plot(Vx,Vy)
    figure
    axis equal
    quiver(impyramid(impyramid(medfilt2(flipud(Vx), [5 5]), 'reduce'), 'reduce'), -impyramid(impyramid(medfilt2(flipud(Vy), [5 5]), 'reduce'), 'reduce'));
end