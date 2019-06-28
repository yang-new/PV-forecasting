function target = PVset_ANN_Forecast(predictors,shortTermPastData,path)    
    %% set featur
    % P1(hour), P2(temp), P3(cloud), P4(solar)
    feature=[5 9 10];
    %% load .mat file
    building_num = num2str(predictors(2,1));
    load_name = '\PV_fitnet_ANN_';
    load_name = strcat(path,load_name,building_num,'.mat');
    load(load_name,'-mat');
    %% ForecastData
    predictors( ~any(predictors,2), : ) = []; 
    [time_steps, ~]= size(predictors);
    %% Test using forecast data
    % use ANN 3 times for reduce ANN's error
    for i_loop = 1:1:3
        net_ANN = net_ANN_loop{i_loop};
        result_ForecastData_ANN_loop = zeros(time_steps,1);
        for i = 1:1:time_steps
                x2_ANN = transpose(predictors(i,feature));
                result_ForecastData_ANN_loop(i,:) = net_ANN(x2_ANN);
        end
        result_ForecastData_ANN{i_loop} = result_ForecastData_ANN_loop;
    end
    result_ForecastData_ANN_premean = result_ForecastData_ANN{1}+result_ForecastData_ANN{2}+result_ForecastData_ANN{3};
    result_ForecastData_ANN_mean = result_ForecastData_ANN_premean/3;
    result_ForecastData_ANN_final = PVset_error_correction(predictors,result_ForecastData_ANN_mean,shortTermPastData);
    %% ResultingData File
    ResultingData_ANN(:,1:10) = predictors(:,1:10);
    ResultingData_ANN(:,12) = result_ForecastData_ANN_final;
    target = ResultingData_ANN(1:time_steps,12);
end