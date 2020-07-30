function leaveControl(sockUDP)

headerData = [68 65 84 65 0];
null=single2bytes(-999);
msgData=repmat(null,1,8); 
msgSend = [headerData int2bytes(11) msgData int2bytes(25) msgData];
fwrite(sockUDP, msgSend);    

end