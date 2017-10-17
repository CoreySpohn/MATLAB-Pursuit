function closestResult = closestPeople(peopleData, currentLoc1, currentLoc2, currentLoc3, currentLoc4)
    %% Choose 5 Closest Agents to Robot
    distanceArray = [];
    for index = 1:size(peopleData,1)
        distance1 = sqrt((peopleData(index,1)-currentLoc1(1))^2+(peopleData(index,2)-currentLoc1(2))^2);
        distance2 = sqrt((peopleData(index,1)-currentLoc2(1))^2+(peopleData(index,2)-currentLoc2(2))^2);
        distance3 = sqrt((peopleData(index,1)-currentLoc3(1))^2+(peopleData(index,2)-currentLoc3(2))^2);
        distance4 = sqrt((peopleData(index,1)-currentLoc4(1))^2+(peopleData(index,2)-currentLoc4(2))^2);

        distanceArray1 = [distanceArray1;[distance1,index]];
        distanceArray2 = [distanceArray1;[distance1,index]];
        distanceArray3 = [distanceArray1;[distance1,index]];
        distanceArray4 = [distanceArray1;[distance1,index]];
    end
    distanceArray = sortrows(distanceArray,1);
    closestResult = distanceArray(1:5);
end