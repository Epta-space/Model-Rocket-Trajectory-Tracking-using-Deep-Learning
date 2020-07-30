 function setCommands(accValue,elevatorValue,aileronValue,rudderValue,sockUDP)
    if accValue > 1
       accValue = 1;
    elseif accValue < -1
           accValue = -1;
    end
    
    if elevatorValue > 1
       elevatorValue = 1;
    elseif elevatorValue < -1
           elevatorValue = -1;
    end
    
    if aileronValue > 1
       aileronValue = 1;
    elseif aileronValue < -1
           aileronValue = -1;
    end
    
    if rudderValue > 1
       rudderValue = 1;
    elseif rudderValue < -1
           rudderValue = -1;
    end
    
    headerData = [68 65 84 65 0];
    null=single2bytes(-999);
    msgData1 = [single2bytes(elevatorValue) single2bytes(aileronValue) single2bytes(rudderValue) null null null null null]; 
    msgData2 = [single2bytes(accValue) null null null null null null null];
    msgSend = [headerData int2bytes(11) msgData1 int2bytes(25) msgData2];
    
    fwrite(sockUDP, msgSend);
end