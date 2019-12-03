anno_files = './Annotations_Part/%s.mat';
examples_path = './JPEGImages';
examples_imgs = dir([examples_path, '/', '*.jpg']);
save_path = './masks';
msk_save_path = './human/masks';
img_save_path = './human/images';

cmap = VOClabelcolormap();

pimap = part2ind();     % part index mapping

for ii = 1:numel(examples_imgs)
    try
        imname = examples_imgs(ii).name;
        img = imread([examples_path, '/', imname]);
        % load annotation -- anno
        load(sprintf(anno_files, imname(1:end-4)));
        [part_mask] = mat2map(anno, img, pimap);
        contains_human = false;
        for idx = 1:numel(anno.objects)
            obj = anno.objects(idx);
            if (obj.class_ind == 15)
                contains_human = true;
                break;
            end
        end
        
        if (contains_human)
            imwrite(img, [img_save_path, '/', imname]);
            
            imname_without_ext = split(imname,'.');
            pngname = strcat(imname_without_ext{1},'.png');
            
            imwrite(part_mask,[msk_save_path, '/', pngname]); 
        end        
    catch
    end
end
