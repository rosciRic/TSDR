function config = initializeConfig()
    config.dataset.csvPath = '../../data/raw/Train.csv';
    config.dataset.imageFolder = '../../data/raw/';
    config.dataset.holdoutRatio = 0.2;
    config.dataset.circleClasses = [0:10, 15:17, 33:40];
    config.dataset.triangleClasses = [11, 13, 18:31];
end