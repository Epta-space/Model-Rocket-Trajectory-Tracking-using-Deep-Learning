%% Encerramento da comunica��o UDP
leaveControl(sockUDP);
display('Encerrando comunica��o UDP...');
fclose(sockUDP);
delete(sockUDP);
clear sockUDP;
display('Comunica��o UDP encerrada.');