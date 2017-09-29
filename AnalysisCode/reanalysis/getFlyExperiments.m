function flyExperiments = getFlyExperiments(expNum)

switch expNum
    case 1
         flyExperiments = [7 1;8 5;9 1;10 1;11 1];
%         flyExperiments = [12 1;13 2];
    case 2
        flyExperiments = [1 2; 2 1;5 1; 6 1;7 1];
    case 3
        flyExperiments = [1 1; 2 1];
    case 4
        flyExperiments = [1 3;2 1;4 1;5 1];
    case 5
        flyExperiments = [2 2; 3 2];
    case 6
        flyExperiments = [4 1; 5 1];
    case 7
        flyExperiments = [1 1; 2 1;3 2];
    case 8
        flyExperiments = [];
    case 9
        flyExperiments = [4 2; 5 2;6 1];
    case 10
        flyExperiments = [];
    case 11
        flyExperiments = [];
    case 12
        flyExperiments = [20 3];
end