function[] = DoMyelin()

addpath(genpath('./utils'));

%% variables: 
hemi = 'L'; % or: 'R'

%% Load data:
[distDMN, zonesDMN] = makeDMNdist_yeo();
if hemi == 'L'
   d = distDMN(1:32492);
elseif hemi == 'R'
    d = distDMN(32493:32492*2);
end
myelin = loadMyelin_group(hemi);
[surf, surfi, surfm] = loadHCPsurf_group(hemi);
[cortex, noncortex] = loadCortex(hemi, surf);
cortex = find(cortex);

% h = figure;
% plot(myelin(cortex), d(cortex), '.');
% xlim([1 2]);

load data/clus.mat
labels_d = zeros(length(surf.coord),1);
labels_m = zeros(length(surf.coord),1);
for i = 1:length(unique(nonzeros(clus.regions)))
    vals_d(i) = mean(d(clus.regions == i));
    labels_d(clus.regions == i) = vals_d(i);
    
    vals_m(i) = mean(myelin(clus.regions == i));
    labels_m(clus.regions == i) = vals_m(i);    
end

figure; SurfStatView(labels_d, surfmL);
figure; SurfStatView(labels_m, surfmL);
SurfStatColLim([1.2 1.5]);


%% 
numClus = length(unique(nonzeros(clus.regions)));
[matrix, s, ind, x, y] = threshGraph(clus, surf, ['results/label' num2str(numClus)]);


WriteSurfMap_scalars(labels_d, 'results/labels_dist_L_18', surfm);
WriteSurfMap_scalars(labels_m, 'results/labels_myelin_L_18', surfm);
WriteSurfMap(data, filename, colors, surf);


h = figure;
a = [1:length(unique(nonzeros(clus.regions)))]'; c = cellstr(num2str(a)); dx = 1; dy = 0;

subplot(2,4,1);
scatter(vals_d,vals_m,'.'); hold on;
text(vals_d+dx, vals_m+dy, c);
title('distance DMN v. myelin');
xlabel('dist'); ylabel('myelin');

subplot(2,4,2);
scatter(x,vals_m,'.'); hold on;
text(x, vals_m, c);
title('smallest eigenvector v. myelin');
xlabel('smallest eigen'); ylabel('myelin');

subplot(2,4,3);
scatter(y,vals_m,'.'); hold on;
text(y, vals_m, c);
title('2nd smallest eigenvector v. myelin');
xlabel('2nd smallest'); ylabel('myelin');

subplot(2,4,4);
scatter(vals_d,x,'.'); hold on;
text(vals_d, x, c);
title('distance DMN v. smallest');
xlabel('dist'); ylabel('smallest');

subplot(2,4,5);
scatter(vals_d,y,'.'); hold on;
text(vals_d, y, c);
title('distance DMN v. 2nd smallest');
xlabel('dist'); ylabel('2nd smallest');

[pcccoeff, pcvec] = pca([x y]');
z = pcvec(:,1);

subplot(2,4,6);
scatter(vals_d,z,'.'); hold on;
text(vals_d, z, c);
title('distance DMN v. pca');
xlabel('dist'); ylabel('pca');

subplot(2,4,7);
scatter(z,vals_m,'.'); hold on;
text(z, vals_m, c);
title('pca v. myelin');
xlabel('pca'); ylabel('myelin');



