@echo off
:: ERROR KILLER - Versao Melhorada
:: Arquivo: tools\error_killer_improved.bat
:: Requer: Executar como Administrador para a maioria das funcoes

setlocal enabledelayedexpansion
color 0A
title ERROR KILLER - Ferramenta de Diagnostico e Reparos

:: --- LOG ---
set TIMESTAMP=%date:~10,4%%date:~4,2%%date:~7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set LOGFILE=%TEMP%\error_killer_%TIMESTAMP%.log
echo [INFO] Inicio da sessao: %date% %time% > "%LOGFILE%"

:: --- CHECAR ADMIN ---
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo.
    echo [AVISO] Este script precisa ser executado como Administrador para funcionar corretamente.
    echo Pretende reiniciar este script com permissao de Administrador? [S/N]
    choice /c SN /n >nul
    if errorlevel 2 goto not_admin
    echo Elevando para administrador...
        :: Cria um wrapper temporario (CMD) que chama este script no diretorio correto
        set "WRAPPER=%TEMP%\error_killer_elevate_%RANDOM%.cmd"
        > "%WRAPPER%" echo @echo off
        >> "%WRAPPER%" echo cd /d "%~dp0"
        >> "%WRAPPER%" echo call "%~f0"
        >> "%WRAPPER%" echo echo.
        >> "%WRAPPER%" echo pause

        :: Abre um CMD elevado que executa o wrapper (usa /k para manter a janela aberta)
        powershell -Command "Start-Process -FilePath '%COMSPEC%' -ArgumentList '/k','\"%WRAPPER%\"' -Verb RunAs -WorkingDirectory '%~dp0'"
        exit /b
)

:: --- UTILIDADES ---
:log
echo [%date% %time%] %~1 >> "%LOGFILE%"
exit /b

:run_and_log
:: Uso: call :run_and_log comando args...
:: Executa o comando e salva saida no log
%* >> "%LOGFILE%" 2>&1
echo. >> "%LOGFILE%"
exit /b

:: --- CABEÇALHO BONITO ---
:header
cls
echo. & echo.
echo  ================================================================
echo  ███████╗ ███████╗██████╗ ███████╗ █████╗ ██╗  ██╗██╗    ██╗
echo  ██╔════╝ ██╔════╝██╔══██╗██╔════╝██╔══██╗██║ ██╔╝██║    ██║
echo  ███████╗ █████╗  ██████╔╝█████╗  ███████║█████╔╝ ██║ █╗ ██║
echo  ╚════██║██╔══╝  ██╔══██╗██╔══╝  ██╔══██║██╔═██╗ ██║███╗██║
echo  ███████║███████╗██║  ██║███████╗██║  ██║██║  ██╗╚███╔███╔╝
echo  ╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚══╝╚══╝ 
echo.
echo  ERROR KILLER - Diagnostico & Reparos (Versao Melhorada)
echo  ================================================================
echo.
echo  Log: %LOGFILE%
echo.
exit /b

:menu
call :header >nul 2>&1
echo [1]  Reiniciar sistema (gracioso)
echo [2]  Flush DNS & Registrar DNS
echo [3]  Diagnostico de rede (salva relatorio)
echo [4]  Correcao de impressao (spooler & drivers)
echo [5]  Painel de Impressoras
echo [6]  Reparos Windows (SFC + DISM)
echo [7]  Seguranca (Firewall / Defender / Auditoria)
echo [8]  Reset de Rede (Winsock / IP)
echo [9]  Backup do Registro (exporta hives)
echo [10] Monitor de Processos (lista e finaliza)
echo [11] Diagnostico Completo (bundle de funcoes)
echo [12] Otimizacao de Energia
echo [13] Desativar apps (com confirmacao)
echo [14] Auditoria (eventos e desempenho)
echo [15] Limpar cache do Windows Update
echo [16] Criar ponto de restauracao (se suportado)
echo [17] Coletar logs + empacotar (ZIP)
echo [H]  Ajuda / Sobre
echo [0]  Sair
echo.
set /p opcao= Selecione uma opcao: 
if /i "%opcao%"=="1" goto reiniciar
if /i "%opcao%"=="2" goto flushdns
if /i "%opcao%"=="3" goto ipall
if /i "%opcao%"=="4" goto correcao_impressao
if /i "%opcao%"=="5" goto impressoras
if /i "%opcao%"=="6" goto correcao_windows
if /i "%opcao%"=="7" goto seguranca
if /i "%opcao%"=="8" goto resetnet
if /i "%opcao%"=="9" goto backupreg
if /i "%opcao%"=="10" goto processos
if /i "%opcao%"=="11" goto diagnostico
if /i "%opcao%"=="12" goto energia
if /i "%opcao%"=="13" goto desativarapps
if /i "%opcao%"=="14" goto auditoria
if /i "%opcao%"=="15" goto limpar_windows_update
if /i "%opcao%"=="16" goto create_restore_point
echo [*] Verificando Windows Defender e Windows Update... >> "%LOGFILE%"
if /i /c "%opcao%"=="H" goto ajuda
if /i "%opcao%"=="0" goto fim
echo.
echo [ERRO] Opcao invalida! Use apenas as opcoes listadas.
timeout /t 2 >nul
goto menu

echo [*] Exibindo configuracao do firewall... >> "%LOGFILE%"
echo Nao foi possivel obter permissao de Administrador. Saindo...
echo [ERRO] Nao-e-admin >> "%LOGFILE%"
timeout /t 2 >nul
exit /b

:: ================= OPERACOES =================
echo [*] Limpando historico (operacao nao destrutiva)... >> "%LOGFILE%"
echo [*] Preparando reinicio... >> "%LOGFILE%"
shutdown /r /t 10 /c "Reinicio iniciado pelo Error Killer" >> "%LOGFILE%" 2>&1
echo Reiniciando em 10 segundos...
pause
goto menu

:flushdns
echo [*] Limpando DNS... >> "%LOGFILE%"
call :run_and_log ipconfig /flushdns
call :run_and_log ipconfig /registerdns
echo [+] DNS limpo! Pressione uma tecla para voltar.
pause
echo [*] Resetando rede... >> "%LOGFILE%"

:ipall
echo [*] Gerando relatorio de rede... >> "%LOGFILE%"
set NETREPORT=%TEMP%\rede_info_%TIMESTAMP%.txt
echo Informacoes de rede - %date% %time% > "%NETREPORT%"
call :run_and_log ipconfig /all >> "%NETREPORT%"
call :run_and_log arp -a >> "%NETREPORT%"
call :run_and_log route print >> "%NETREPORT%"
start notepad "%NETREPORT%"
echo Relatorio salvo em: %NETREPORT%
echo [*] Realizando backup do registro... >> "%LOGFILE%"
pause
goto menu

:correcao_impressao
cls
echo [1] Reiniciar spooler
echo [2] Aplicar correcoes conhecidas (RPC, Drivers, NamedPipe)
echo [3] Ver filas e imprimir teste
echo [0] Voltar
set /p escolha= Selecione: 
if "%escolha%"=="1" goto reiniciar_spooler
echo [*] Aplicando esquema de energia de alto desempenho... >> "%LOGFILE%"
if "%escolha%"=="3" goto ver_filas_impressao
if "%escolha%"=="0" goto menu
goto correcao_impressao

:reiniciar_spooler
echo [*] Reiniciando spooler... >> "%LOGFILE%"
call :run_and_log net stop spooler /y
echo [*] Desativacao de apps e servicos (com confirmacao)... >> "%LOGFILE%"
echo [+] Spooler reiniciado!
call :log "Spooler reiniciado"
pause
goto menu

:todos_reparos_impressao
echo [*] Aplicando correcoes de impressao (com backup de registry)... >> "%LOGFILE%"
:: Faz backup da chave antes de alterar
    reg export "HKLM\SYSTEM\CurrentControlSet\Control\Print" "%TEMP%\print_key_backup.reg" /y >> "%LOGFILE%" 2>&1
call :run_and_log reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v RpcAuthnLevelPrivacyEnabled /t REG_DWORD /d 0 /f
call :run_and_log reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint" /v RestrictDriverInstallationToAdministrators /t REG_DWORD /d 0 /f
call :run_and_log reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC" /v RpcUseNamedPipeProtocol /t REG_DWORD /d 1 /f
call :run_and_log net stop spooler /y
call :run_and_log net start spooler
echo [*] Limpando cache do Windows Update... >> "%LOGFILE%"
call :log "Correcoes de impressao aplicadas"
pause
goto menu

:ver_filas_impressao
echo Filas de impressao ativas:
call :run_and_log powershell -Command "Get-PrintJob -ComputerName $env:COMPUTERNAME | Format-Table -AutoSize"
pause
goto correcao_impressao

:impressoras
start control printers
echo [*] Tentando criar ponto de restauracao (pode falhar se desabilitado)... >> "%LOGFILE%"
call :log "Painel de Impressoras aberto"
pause
goto menu

:correcao_windows
cls
echo [1] SFC /scannow
echo [2] DISM /RestoreHealth
echo [3] CHKDSK (scan)
echo [0] Voltar
set /p escolha= Selecione: 
if "%escolha%"=="1" goto diag_sfc
if "%escolha%"=="2" goto diag_dism
echo [*] Coletando logs e empacotando... >> "%LOGFILE%"
if "%escolha%"=="0" goto menu
goto correcao_windows

:diag_sfc
echo [*] Executando SFC /scannow... >> "%LOGFILE%"
call :run_and_log sfc /scannow
call :log "SFC executado"
pause
goto menu

:diag_dism
echo [*] Executando DISM... >> "%LOGFILE%"
call :run_and_log DISM /Online /Cleanup-Image /RestoreHealth
call :log "DISM executado"
pause
goto menu

:diag_chkdsk
echo [*] Executando CHKDSK (scan)... >> "%LOGFILE%"
call :run_and_log chkdsk /scan
call :log "CHKDSK executado"
pause
goto menu

:seguranca
cls
echo [1] Verificar Windows Update / Defender status
echo [2] Verificar Firewall (exibir perfis)
echo [3] Limpar rastreamentos (com cautela)
echo [0] Voltar
set /p escolha= Selecione: 
if "%escolha%"=="1" goto verificar_defender
if "%escolha%"=="2" goto verificar_firewall
if "%escolha%"=="3" goto limpar_rastreamentos
if "%escolha%"=="0" goto menu
goto seguranca

:verificar_defender
echo [*] Verificando Windows Defender e Windows Update... >> "%LOGFILE%"
call :run_and_log sc query WinDefend
call :run_and_log powershell -Command "Get-Service wuauserv | Format-Table -AutoSize"
call :log "Defender/Update status exibido"
pause
goto seguranca

:verificar_firewall
echo [*] Exibindo configuracao do firewall... >> "%LOGFILE%"
call :run_and_log netsh advfirewall show allprofiles
call :log "Firewall verificado"
pause
goto seguranca

:limpar_rastreamentos
echo [*] Limpando historico (operacao nao destrutiva)... >> "%LOGFILE%"
echo [!] Isto remove historico local e caches temporarios. Continuar? [S/N]
choice /c SN /n >nul
if errorlevel 2 goto seguranca
echo Limpando historico do Windows... >> "%LOGFILE%"
call :run_and_log del /f /s /q "%localappdata%\Microsoft\Windows\History\*" >> "%LOGFILE%" 2>&1
call :run_and_log del /f /s /q "%localappdata%\Microsoft\Windows\Recent\*" >> "%LOGFILE%" 2>&1
call :log "Rastreamentos limpos"
echo [+] Limpeza concluida.
pause
goto seguranca

:resetnet
echo [*] Resetando rede... >> "%LOGFILE%"
call :run_and_log netsh winsock reset
call :run_and_log netsh int ip reset
call :run_and_log ipconfig /release
call :run_and_log ipconfig /renew
call :log "Rede resetada"
echo [+] Rede resetada com sucesso!
pause
goto menu

:backupreg
echo [*] Realizando backup do registro... >> "%LOGFILE%"
set BACKUP_DIR=%~dp0RegBackup_%TIMESTAMP%
mkdir "%BACKUP_DIR%" >nul 2>&1
    call :run_and_log reg export HKLM "%BACKUP_DIR%\HKLM.reg" /y
call :run_and_log reg export HKCU "%BACKUP_DIR%\HKCU.reg" /y
call :run_and_log reg export HKCR "%BACKUP_DIR%\HKCR.reg" /y
call :log "Backup de registro salvo em %BACKUP_DIR%"
echo Backup salvo em: %BACKUP_DIR%
pause
goto menu

:processos
cls
echo [1] Listar processos (tasklist)
echo [2] Listar processos de rede (netstat)
echo [3] Finalizar processo por PID
echo [0] Voltar
set /p escolha= Selecione: 
if "%escolha%"=="1" (
    call :run_and_log tasklist
    pause
    goto processos
)
if "%escolha%"=="2" (
    call :run_and_log netstat -ano | findstr "ESTABLISHED"
    pause
    goto processos
)
if "%escolha%"=="3" (
    set /p pid= Digite o PID: 
    echo Finalizando PID %pid% >> "%LOGFILE%"
    call :run_and_log taskkill /F /PID %pid%
    pause
    goto processos
)
if "%escolha%"=="0" goto menu
goto processos

:diagnostico
cls
echo Iniciando diagnostico completo... >> "%LOGFILE%"
echo Este processo executara varias funcoes de diagnostico e reparo.
choice /c SY /n /m "Deseja continuar? S/N"
if errorlevel 2 goto menu

    :: Executa um bundle seguro (SFC, DISM, FlushDNS, Reset Net)
call :log "Diagnostico completo - iniciado"
call :run_and_log sfc /scannow
call :run_and_log DISM /Online /Cleanup-Image /RestoreHealth
call :run_and_log ipconfig /flushdns
call :run_and_log netsh winsock reset
call :run_and_log netsh int ip reset
call :log "Diagnostico completo - finalizado"
echo [+] Diagnostico completo finalizado. Verifique o log: %LOGFILE%
pause
goto menu

:energia
echo [*] Aplicando esquema de energia de alto desempenho... >> "%LOGFILE%"
call :run_and_log powercfg /setactive SCHEME_MIN
call :log "Energia otimizada"
echo [+] Otimizacao aplicada.
pause
goto menu

:desativarapps
echo [*] Desativacao de apps e servicos (com confirmacao)... >> "%LOGFILE%"
echo ATENCAO: Isto pode alterar politicas e desabilitar servicos. Continuar? [S/N]
choice /c SN /n >nul
if errorlevel 2 goto menu

    :: Exemplo de desativacao segura (telemetria opcional)
call :run_and_log reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
call :run_and_log sc config "DiagTrack" start= disabled
call :run_and_log sc stop DiagTrack >nul 2>&1
call :log "Apps/servicos minimizados"
echo [+] Configuracoes aplicadas.
pause
goto menu

:auditoria
cls
echo [1] Ultimos erros do sistema (System)
echo [2] Eventos de seguranca
echo [3] Relatorio de desempenho (perfmon)
echo [0] Voltar
set /p escolha= Selecione: 
if "%escolha%"=="1" (
    call :run_and_log wevtutil qe System /c:20 /f:text | findstr /i /C:"erro" /C:"error" /C:"falha"
    pause
    goto auditoria
)
if "%escolha%"=="2" (
    call :run_and_log wevtutil qe Security /c:20 /f:text
    pause
    goto auditoria
)
if "%escolha%"=="3" (
    start perfmon /report
    call :log "Relatorio de desempenho iniciado"
    timeout /t 2 >nul
    goto auditoria
)
if "%escolha%"=="0" goto menu
goto auditoria

:limpar_windows_update
echo [*] Limpando cache do Windows Update... >> "%LOGFILE%"
call :run_and_log net stop wuauserv
call :run_and_log net stop bits
call :run_and_log ren "%windir%\SoftwareDistribution" "SoftwareDistribution.old"
call :run_and_log ren "%windir%\System32\catroot2" "catroot2.old"
call :run_and_log net start bits
call :run_and_log net start wuauserv
call :log "Cache do Windows Update limpo (renomeado)"
echo [+] Cache renomeado. Reinicie se necessario.
pause
goto menu

:create_restore_point
echo [*] Tentando criar ponto de restauracao (pode falhar se desabilitado)... >> "%LOGFILE%"
:: Usa PowerShell para criar um ponto de restauracao. Requer System Restore habilitado.
powershell -Command "Try { Checkpoint-Computer -Description 'ErrorKiller_Restore' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop; Write-Output 'OK' } Catch { Write-Output 'ERRO:'; Write-Output $_.Exception.Message; exit 1 }"  >> "%LOGFILE%" 2>&1
if %errorlevel% EQU 0 (
    echo [+] Ponto de restauracao criado com sucesso.
    call :log "Ponto de restauracao criado"
) else (
    echo [!] Nao foi possivel criar o ponto. Verifique se a Protecao do Sistema esta habilitada.
    call :log "Falha ao criar ponto de restauracao"
)
pause
goto menu

:coletar_logs
echo [*] Coletando logs e empacotando... >> "%LOGFILE%"
set OUTDIR=%TEMP%\error_killer_logs_%TIMESTAMP%
mkdir "%OUTDIR%" >nul 2>&1
call :run_and_log wevtutil qe System /c:200 /f:text > "%OUTDIR%\system_events.txt"
call :run_and_log ipconfig /all > "%OUTDIR%\network.txt"
call :run_and_log tasklist > "%OUTDIR%\tasklist.txt"
call :run_and_log netstat -ano > "%OUTDIR%\netstat.txt"
call :run_and_log reg export HKLM "%OUTDIR%\HKLM.reg" /y >nul 2>&1

    powershell -Command "Try { Compress-Archive -Path '%OUTDIR%\*' -DestinationPath '%OUTDIR%.zip' -Force; Write-Output 'OK' } Catch { Write-Output 'ERRO' }" >> "%LOGFILE%" 2>&1
if exist "%OUTDIR%.zip" (
    echo [+] Logs empacotados em: %OUTDIR%.zip
    call :log "Logs empacotados: %OUTDIR%.zip"
) else (
    echo [!] Falha ao empacotar logs. Verifique o log: %LOGFILE%
)
pause
goto menu

:ajuda
cls
echo ERROR KILLER - Ajuda breve
echo - Execute este script como Administrador para ter acesso a todas as funcoes.
echo - As operacoes que alteram o sistema pedirao confirmacao quando necessario.
echo - Os logs sao salvos em: %LOGFILE%
pause
goto menu

:fim
call :log "Sessao finalizada"
echo Obrigado por usar o Error Killer. Saindo...
endlocal
exit /b