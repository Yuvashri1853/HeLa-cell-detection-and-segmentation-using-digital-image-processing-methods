function nucleos = dv_checkNucinCell(cell, nuclei)

[u,v] = size(cell);

CC_cell = bwconncomp(cell);
numCells = cellfun(@numel, CC_cell.PixelIdxList);
[x_c,y_c] = size(numCells);
CC_nuc = bwconncomp(nuclei);
numNucs = cellfun(@numel, CC_nuc.PixelIdxList);
[x_n,y_n] = size(numNucs);
nucleos = zeros(u,v);
x_img = u/2;
y_img = v/2;



if y_c ~= 0
    for n=1:y_n
        nuc = zeros(u,v);
        nuc(CC_nuc.PixelIdxList{n}) = 255;
        cont = 0;
        for c=1:y_c
            cell = zeros(u,v);
            cell(CC_cell.PixelIdxList{c}) = 255;
            for i=1:u
                for j=1:v
                    if nuc(i,j) == 255 && cell(i,j) == 0
                        cont = cont + 1;
                    end
                end
            end
           
            if cont < 150 %%120 cambiar
                [xC, yC] = centros(nuc);
                dC = sqrt((xC - x_img)*(xC - x_img) + (yC - y_img)*(yC - y_img));
                if dC < 75
                     nucleos(CC_nuc.PixelIdxList{n}) = 255;
                end
            end

        end
    end
end




end

