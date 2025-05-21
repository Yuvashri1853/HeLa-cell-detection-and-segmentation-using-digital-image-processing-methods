function nucleos = dv_closeNucleis(I, nucprop, cell)
    [u,v] = size(I);
    if u ~= 500 || v ~= 500
        I = imresize(I, [500, 500]);
    end
    co = 0;
    for i =1:500
        for j=1:500
            if nucprop(i,j) == 255
                co = co + 1;
            end
        end
    end
    if co < 3000
         seM = strel('disk', 2);
    else
         seM = strel('disk', 3);
    end    
    I = imgaussfilt(I,.2);
    BW = im2bw(I, graythresh(I));
    BW = one2zero(BW);
    [u, v] = size(BW);
    BWI = zeros(u,v);
    BW = double(BW);
    mask = zeros(u,v);
    for i=1:u
        for j=1:v
            BWI(i,j) = I(i,j) * BW(i,j);
            if BWI(i,j) > 94 && BWI(i,j) < 130
                mask(i,j) = 255;
            end
        end
    end
    maskd = imdilate(mask, seM); 
    maskdi = zeros(u,v);
    for i=1:u
        for j=1:v
            if maskd(i,j) == 255
                maskdi(i,j) = 0;
            else
                maskdi(i,j) = 255;
            end
        end
    end
    nucprop = bwareaopen(nucprop, 300);
    maskdi = bwareaopen(maskdi, 300);
    CC_nucprop = bwconncomp(nucprop);
    numNucsprop = cellfun(@numel, CC_nucprop.PixelIdxList);
    [x_np,y_np] = size(numNucsprop);
    CC_nuc = bwconncomp(maskdi);
    numNucs = cellfun(@numel, CC_nuc.PixelIdxList);
    [x_n,y_n] = size(numNucs);
    CC_cell = bwconncomp(cell);
    numCells = cellfun(@numel, CC_cell.PixelIdxList);
    [x_c,y_c] = size(numCells)
    nucleos = zeros(u,v);
    realNucs = zeros(u,v);
    if y_np == 0 || y_n == 0
        realNucs = zeros(u,v);
    else
        for n=1:y_n
            nuc = zeros(u,v);
            nuc(CC_nuc.PixelIdxList{n}) = 255;
            nuc = imfill(nuc, 'holes');
            [xN, yN] = centros(nuc);
            for c=1:y_np
                propNuc = zeros(u,v);
                propNuc(CC_nucprop.PixelIdxList{c}) = 255;
                [xC, yC] = centros(propNuc);
                dC = sqrt((xC - xN)*(xC - xN) + (yC - yN)*(yC - yN));           
                if dC < 70
                   % fprintf('distance satisfied');
                    tamobj1 = (numNucsprop(c)*100)/(u*v);
                    tamobj2 = (numNucs(n)*100)/(u*v);
                    if tamobj1 > 5 && tamobj2 > 5
                        vmin = 0.01;
                        vmax = 1.5;
                    else
                        vmin = 0.01;
                        vmax = 7;
                    end
                    rel = tamobj2/tamobj1;
                    if rel > vmin && rel < vmax %60
                        %fprintf('vmin vmax');
                        realNucs(CC_nuc.PixelIdxList{n}) = 255;
                        if co > 3000
                            se = strel('sphere', 4);
                            realNucs = imdilate(realNucs, se);
                        else
                            se = strel('sphere', 3);
                            realNucs = imdilate(realNucs, se);
                        end
                        realNucs = imfill(realNucs, 'holes');
                        [xN, yN] = centros(realNucs);
                        if y_c ~= 0
                            for d=1:y_c
                                pcell = zeros(u,v);
                                pcell(CC_cell.PixelIdxList{d}) = 255;
                                [xc, yc] = centros(pcell);
                                dc = sqrt((xc - xN)*(xc - xN) + (yc - yN)*(yc - yN));
                                if dc < 65
                                    nucleos = nucleos + realNucs;
                                end
                            end
                        end
                    end
                end
            end
        end  
    end
end

