function closestResult = closestPeople(peopleData, currentLoc1, currentLoc2, currentLoc3, currentLoc4)
    %% Choose 5 Closest Agents to Robot
    distanceArray = [];
    for index = 1:size(peopleData,1)
        distance1 = sqrt((peopleData(index,1)-currentLoc1(1))^2+(peopleData(index,2)-currentLoc1(2))^2);
        distance2 = sqrt((peopleData(index,1)-currentLoc2(1))^2+(peopleData(index,2)-currentLoc2(2))^2);
        distance3 = sqrt((peopleData(index,1)-currentLoc3(1))^2+(peopleData(index,2)-currentLoc3(2))^2);
        distance4 = sqrt((peopleData(index,1)-currentLoc4(1))^2+(peopleData(index,2)-currentLoc4(2))^2);

        distanceArray1 = [distanceArray1;[distance1,index]];
        distanceArray2 = [distanceArray2;[distance2,index]];
        distanceArray3 = [distanceArray3;[distance3,index]];
        distanceArray4 = [distanceArray4;[distance4,index]];
    end
    %Check if sortrows() sorts by high to low or low to high
    distanceArray1 = sortrows(distanceArray1,1);
    distanceArray2 = sortrows(distanceArray2,1);
    distanceArray3 = sortrows(distanceArray3,1);
    distanceArray4 = sortrows(distanceArray4,1);
    
    closestResult = [distanceArray1(1:5);distanceArray2(1:5);distanceArray3(1:5);distanceArray4(1:5)];
end