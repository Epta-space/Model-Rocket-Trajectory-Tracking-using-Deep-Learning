%% Encerramento da comunicação UDP
leaveControl(sockUDP);
display('Encerrando comunicação UDP...');
fclose(sockUDP);
delete(sockUDP);
clear sockUDP;
display('Comunicação UDP encerrada.');