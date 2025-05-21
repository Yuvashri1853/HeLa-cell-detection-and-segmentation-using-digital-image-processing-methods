function nucleos = dv_checkRound(nucleos)
    [u,v] = size(nucleos);
    nucleos = bwareaopen(nucleos,500);
    CC = bwconncomp(nucleos);
    numNucs = cellfun(@numel, CC.PixelIdxList);
    [x,y] = size(numNucs);
    nucR = zeros(u,v);
    
   
    if numNucs ~= 0
        for i=1:y
              obj = zeros(u,v);
              obj(CC.PixelIdxList{i}) = 255;
              [B,L] = bwboundaries(obj,'noholes');
              stats = regionprops(L,'Area','Centroid');
              boundary = B{1};
              delta_sq = diff(boundary).^2;    
              perimeter = sum(sqrt(sum(delta_sq,2)));
              area = stats(1).Area;
              metric = 4*pi*area/perimeter^2;
              
              if metric > 0.1
                    nucR(CC.PixelIdxList{i}) = 255;
              end
        end
    end
    


    nucleos = nucR;
    

end