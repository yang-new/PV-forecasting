clear all
clc
close all
warning('off','all');
y_pred = getPVModel([pwd,'\','PST_201902082359.csv'],...
                        [pwd,'\','PFP_201902082359.csv'],...
                        [pwd,'\','ResultData.csv'])