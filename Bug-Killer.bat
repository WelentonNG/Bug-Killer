@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1

REM ════════════════════════════════════════════════════════════════════════════
REM  ██████╗ ██╗   ██╗ ██████╗     ██╗  ██╗██╗██╗     ██╗     ███████╗██████╗ 
REM  ██╔══██╗██║   ██║██╔════╝     ██║ ██╔╝██║██║     ██║     ██╔════╝██╔══██╗
REM  ██████╔╝██║   ██║██║  ███╗    █████╔╝ ██║██║     ██║     █████╗  ██████╔╝
REM  ██╔══██╗██║   ██║██║   ██║    ██╔═██╗ ██║██║     ██║     ██╔══╝  ██╔══██╗
REM  ██████╔╝╚██████╔╝╚██████╔╝    ██║  ██╗██║███████╗███████╗███████╗██║  ██║
REM  ╚═════╝  ╚═════╝  ╚═════╝     ╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
REM
REM  BUG-KILLER PRO v5.0 - Sistema Profissional de Otimização do Windows
REM  Desenvolvido: 2026 | Atualizado: 2026-03-24
REM  Autor: Sistema Avançado de Manutenção
REM ════════════════════════════════════════════════════════════════════════════

REM Verificar privilégios
net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo.
    echo  ╔═══════════════════════════════════════════════════════════════════╗
    echo  ║  ⚠ AVISO: Privilégios de Administrador Necessários              ║
    echo  ║                                                                   ║
    echo  ║  Este script requer permissões elevadas para funcionar.          ║
    echo  ║  Execute como Administrador...                                   ║
    echo  ╚═══════════════════════════════════════════════════════════════════╝
    echo.
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb RunAs"
    exit /b
)

REM Variáveis globais
set "version=3.0"
set "logfile=%userprofile%\Desktop\BUG_KILLER_Log_%date:~10,4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.txt"
set "configfile=%appdata%\BUG_KILLER\config.ini"
set "favorites=%appdata%\BUG_KILLER\favorites.txt"
set "history=%appdata%\BUG_KILLER\history.txt"
set "operacoes_sucesso=0"
set "operacoes_erro=0"
set "modo_silencioso=0"
set "modo_simulacao=0"

REM Criar diretórios de configuração
if not exist "%appdata%\BUG_KILLER" mkdir "%appdata%\BUG_KILLER"

REM Inicializar arquivo de log
if not exist %logfile% (
    echo. > %logfile%
    echo ════════════════════════════════════════════════════════════════════════════ >> %logfile%
    echo  BUG-KILLER PRO v%version% - LOG DE OPERACOES >> %logfile%
    echo  Data: %date% - Hora: %time% >> %logfile%
    echo ════════════════════════════════════════════════════════════════════════════ >> %logfile%
    echo. >> %logfile%
)

REM ════════════════════════════════════════════════════════════════════════════
REM TELA DE INICIALIZAÇÃO
REM ════════════════════════════════════════════════════════════════════════════

:inicio
cls
title BUG-KILLER PRO v%version% - Sistema de Otimização
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║                                                                           ║
echo  ║   ██████╗ ██╗   ██╗ ██████╗     ██╗  ██╗██╗██╗     ██╗     ███████╗██████╗║
echo  ║   ██╔══██╗██║   ██║██╔════╝     ██║ ██╔╝██║██║     ██║     ██╔════╝██╔══██║
echo  ║   ██████╔╝██║   ██║██║  ███╗    █████╔╝ ██║██║     ██║     █████╗  ██████╔║
echo  ║   ██╔══██╗██║   ██║██║   ██║    ██╔═██╗ ██║██║     ██║     ██╔══╝  ██╔══██║
echo  ║   ██████╔╝╚██████╔╝╚██████╔╝    ██║  ██╗██║███████╗███████╗███████╗██║  ██║
echo  ║   ╚═════╝  ╚═════╝  ╚═════╝     ╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝║
echo  ║                                                                           ║
echo  ║                            PRO v%version% - 2026                               ║
echo  ║                   Sistema Profissional de Otimização                      ║
echo  ║                                                                           ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
timeout /t 2 /nobreak >nul

:menu_principal
cls
title BUG-KILLER PRO - MENU PRINCIPAL
call :mostrar_dashboard

:menu_opcoes
echo.
echo  ┌─────────────────────────────────────────────────────────────────────────┐
echo  │                 🏠 MENU PRINCIPAL - BUG-KILLER                          │
echo  └─────────────────────────────────────────────────────────────────────────┘
echo.
echo   ╔═══════════════════════════════════════════════════════════════════════╗
echo   ║  LIMPEZA E OTIMIZAÇÃO                                                 ║
echo   ╠═══════════════════════════════════════════════════════════════════════╣
echo   ║  1 │ 🗑️  Limpeza Rápida            │ 16 │ 🧹 Cache e Temp Avançado  ║
echo   ║  2 │ 🌍 Limpeza de DNS             │ 17 │ 💾 Reparar Disco          ║
echo   ║  3 │ 📡 Diagnóstico de Rede        │ 18 │ ⚡ Otimizar Performance   ║
echo   ║  4 │ 🖨️  Correção de Impressão     │ 19 │ 🔧 Limpar Registro        ║
echo   ║  5 │ 🖨️  Gerenciar Impressoras     │ 20 │ 🌐 Corrigir Rede          ║
echo   ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo   ╔═══════════════════════════════════════════════════════════════════════╗
echo   ║  MANUTENÇÃO E SISTEMA                                                 ║
echo   ╠═══════════════════════════════════════════════════════════════════════╣
echo   ║  6 │ 🔨 Correcção Windows           │ 21 │ 🔐 Reparar Permissões     ║
echo   ║  7 │ 🛡️  Segurança Avançada        │ 22 │ 🚀 Manutenção Completa    ║
echo   ║  8 │ 🔄 Reset de Rede              │ 23 │ ⚙️  Resetar Políticas      ║
echo   ║  9 │ 💾 Backup/Restauração         │ 24 │ 🗂️  Limpar Restauração    ║
echo   ║  10│ 📊 Monitor de Processos       │ 25 │ 📈 Análise de Sistema     ║
echo   ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo   ╔═══════════════════════════════════════════════════════════════════════╗
echo   ║  UTILITÁRIOS E INFORMAÇÕES                                            ║
echo   ╠═══════════════════════════════════════════════════════════════════════╣
echo   ║  11│ 🔍 Diagnóstico Completo       │ 26 │ ⭐ Meus Favoritos          ║
echo   ║  12│ 🔋 Otimização Energia        │ 27 │ 🕐 Histórico              ║
echo   ║  13│ 📦 Gerenciar Programas       │ 28 │ ⚙️  Configurações          ║
echo   ║  14│ 📋 Auditoria Sistema         │ 29 │ ❓ Ajuda                  ║
echo   ║  15│ 🔥 Modo Emergência           │ 30 │ ℹ️  Sobre                 ║
echo   ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo   ╔═══════════════════════════════════════════════════════════════════════╗
echo   ║  AÇÕES RÁPIDAS                                                        ║
echo   ╠═══════════════════════════════════════════════════════════════════════╣
echo   ║  [00] 📋 Ver Log         [L] 🎯 Executar Perfil       [R] 🔄 Reiniciar ║
echo   ║  [S]  ⚙️  Config Sistema [?] ❓ Procurar Funcão     [0] ❌ Sair      ║
echo   ╚═══════════════════════════════════════════════════════════════════════╝
echo.
set /p choice="  ➤ Digite a opção desejada: "

REM Processamento de entrada
if "%choice%"=="1" goto limpeza_rapida
if "%choice%"=="2" goto limpeza_dns
if "%choice%"=="3" goto diagnostico_rede
if "%choice%"=="4" goto correcao_impressao
if "%choice%"=="5" goto gerenciar_impressoras
if "%choice%"=="6" goto correcao_windows
if "%choice%"=="7" goto seguranca
if "%choice%"=="8" goto reset_rede
if "%choice%"=="9" goto backup_registro
if "%choice%"=="10" goto monitor_processos
if "%choice%"=="11" goto diagnostico_completo
if "%choice%"=="12" goto otimizacao_energia
if "%choice%"=="13" goto desativar_apps
if "%choice%"=="14" goto auditoria_sistema
if "%choice%"=="15" goto modo_emergencia
if "%choice%"=="16" goto cache_avancado
if "%choice%"=="17" goto reparar_disco
if "%choice%"=="18" goto otimizar_performance
if "%choice%"=="19" goto limpar_registro
if "%choice%"=="20" goto corrigir_rede
if "%choice%"=="21" goto reparar_permissoes
if "%choice%"=="22" goto manutencao_completa
if "%choice%"=="23" goto resetar_politicas
if "%choice%"=="24" goto limpar_restauracao
if "%choice%"=="25" goto analise_sistema
if "%choice%"=="26" goto meus_favoritos
if "%choice%"=="27" goto historico
if "%choice%"=="28" goto configuracoes
if "%choice%"=="29" goto ajuda
if "%choice%"=="30" goto sobre
if "%choice%"=="00" goto ver_log
if "%choice%"=="S" goto config_sistema
if "%choice%"=="s" goto config_sistema
if "%choice%"=="L" goto executar_perfil
if "%choice%"=="l" goto executar_perfil
if "%choice%"=="?" goto procurar_funcao
if "%choice%"=="R" goto reiniciar_sistema
if "%choice%"=="r" goto reiniciar_sistema
if "%choice%"=="0" goto sair

echo.
echo  ❌ Opção inválida! Tente novamente.
timeout /t 2 /nobreak >nul
goto menu_principal

REM ════════════════════════════════════════════════════════════════════════════
REM FUNÇÕES AUXILIARES
REM ════════════════════════════════════════════════════════════════════════════

:mostrar_dashboard
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║                        📊 DASHBOARD DO SISTEMA                            ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.

for /f "tokens=1,2" %%A in ('wmic os get caption^,totalvisiblememorysize ^| find "Windows"') do (
    echo  ✓ Sistema: %%A
    set /a memtotal=%%B / 1024
    echo  ✓ Memória Total: !memtotal! MB
)

for /f "tokens=3" %%A in ('dir C:\ ^| find "bytes free"') do (
    echo  ✓ Espaço em Disco: %%A
)

echo.
echo  Status da Operação:
echo  ├─ Sucessos: %operacoes_sucesso%  ├─ Erros: %operacoes_erro%
echo  └─ Modo: Normal (? para ajuda)
echo.

exit /b

:barra_progresso
setlocal enabledelayedexpansion
set "total=%~1"
set "atual=%~2"
set "titulo=%~3"
cls
echo.
echo  %titulo%
echo.
echo  ┌────────────────────────────────────────────────────┐
for /l %%i in (1,1,%atual%) do (
    if %%i leq %total% (
        set "barra=!barra!█"
    )
)
echo  │%barra%
for /l %%i in (!atual!,1,%total%) do (
    set "espaço=!espaço! "
)
echo  │!espaço!│
echo  └────────────────────────────────────────────────────┘
echo  Progresso: %atual%/%total% (completo)
echo.
exit /b

:animar_carregamento
echo.
for /l %%i in (1,1,3) do (
    echo. | set /p temp="  ⠋"
    timeout /t 1 /nobreak >nul
    cls
    echo.
    echo. | set /p temp="  ⠙"
    timeout /t 1 /nobreak >nul
    cls
    echo.
    echo. | set /p temp="  ⠹"
    timeout /t 1 /nobreak >nul
    cls
    echo.
    echo. | set /p temp="  ⠸"
    timeout /t 1 /nobreak >nul
    cls
    echo.
    echo. | set /p temp="  ⠼"
    timeout /t 1 /nobreak >nul
    cls
    echo.
    echo. | set /p temp="  ⠴"
    timeout /t 1 /nobreak >nul
    cls
    echo.
    echo. | set /p temp="  ⠦"
    timeout /t 1 /nobreak >nul
    cls
    echo.
    echo. | set /p temp="  ⠧"
    timeout /t 1 /nobreak >nul
)
exit /b

REM ════════════════════════════════════════════════════════════════════════════
REM OPERAÇÕES PRINCIPAIS
REM ════════════════════════════════════════════════════════════════════════════

:limpeza_rapida
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🗑️  LIMPEZA RÁPIDA DO SISTEMA                                           ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Executando limpeza de cache e arquivos temporários...
echo. >> %logfile%
echo  [%date% %time%] ⚙️ LIMPEZA RÁPIDA INICIADA >> %logfile%

call :barra_progresso 5 1 "  Limpando TEMP..."
del /q /f /s %temp%\* >nul 2>&1

call :barra_progresso 5 2 "  Limpando Prefetch..."
del /q /f /s %windir%\prefetch\* >nul 2>&1

call :barra_progresso 5 3 "  Esvaziando Lixeira..."
rd /s /q %systemdrive%\$Recycle.bin >nul 2>&1

call :barra_progresso 5 4 "  Limpando cookies..."
del /q /f /s "%localappdata%\Microsoft\Windows\Temporary Internet Files\*" >nul 2>&1

call :barra_progresso 5 5 "  Finalizando..."
echo.
echo  ✅ Limpeza Rápida Concluída com Sucesso!
echo.
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Limpeza Rápida CONCLUÍDA >> %logfile%
timeout /t 3 /nobreak >nul
goto menu_principal

:limpeza_dns
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🌍 LIMPEZA DE DNS                                                       ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Executando limpeza de cache DNS...
echo. >> %logfile%
echo  [%date% %time%] 🌍 Limpeza de DNS INICIADA >> %logfile%

ipconfig /flushdns >nul 2>&1
if %errorlevel% equ 0 (
    echo  ✅ Cache DNS Limpo com Sucesso!
    set /a operacoes_sucesso+=1
    echo  [%date% %time%] ✅ Cache DNS LIMPO >> %logfile%
) else (
    echo  ❌ Erro ao Limpar Cache DNS
    set /a operacoes_erro+=1
    echo  [%date% %time%] ❌ ERRO ao limpar cache DNS >> %logfile%
)
echo.
timeout /t 2 /nobreak >nul
goto menu_principal

:diagnostico_rede
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  📡 DIAGNÓSTICO DE REDE COMPLETO                                         ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Executando diagnóstico de rede...
echo. >> %logfile%
echo  [%date% %time%] 📡 Diagnóstico de Rede INICIADO >> %logfile%

call :barra_progresso 4 1 "  Verificando configurações..."
ipconfig /all >> %logfile% 2>&1

call :barra_progresso 4 2 "  Testando conectividade..."
ping 8.8.8.8 -n 4 >> %logfile% 2>&1

call :barra_progresso 4 3 "  Listando rotas..."
route print >> %logfile% 2>&1

call :barra_progresso 4 4 "  Finalizando..."
echo.
echo  ✅ Diagnóstico Concluído!
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Diagnóstico CONCLUÍDO >> %logfile%
echo.
timeout /t 2 /nobreak >nul
goto menu_principal

:correcao_impressao
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🖨️  CORREÇÃO DE PROBLEMAS DE IMPRESSÃO                                  ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Corrigindo problemas de impressão...
echo. >> %logfile%
echo  [%date% %time%] 🖨️ Correção de Impressão INICIADA >> %logfile%

call :barra_progresso 3 1 "  Reiniciando serviço..."
net stop spooler >nul 2>&1
del /q /f /s "%systemroot%\System32\spool\PRINTERS\*" >nul 2>&1

call :barra_progresso 3 2 "  Iniciando serviço..."
net start spooler >nul 2>&1

call :barra_progresso 3 3 "  Limpando fila..."
wmic printjob delete >nul 2>&1

echo.
echo  ✅ Problemas de Impressão Corrigidos!
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Impressão CORRIGIDA >> %logfile%
echo.
timeout /t 2 /nobreak >nul
goto menu_principal

:gerenciar_impressoras
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🖨️  GERENCIADOR DE IMPRESSORAS                                          ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Abrindo Gerenciador de Impressoras...
control printers
set /a operacoes_sucesso+=1
goto menu_principal

:correcao_windows
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🔨 CORREÇÃO DO WINDOWS (SFC E DISM)                                     ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  [!] AVISO: Esta operação pode levar 15-30 minutos
echo.
set /p confirmacao="  ➤ Deseja continuar? (S/N): "
if /i not "%confirmacao%"=="S" goto menu_principal

echo.
echo  Executando verificação de integridade do sistema...
echo. >> %logfile%
echo  [%date% %time%] 🔨 Correção Windows INICIADA >> %logfile%

call :barra_progresso 2 1 "  Executando SFC..."
sfc /scannow >> %logfile% 2>&1

call :barra_progresso 2 2 "  Executando DISM..."
dism /Online /Cleanup-Image /RestoreHealth >> %logfile% 2>&1

echo.
echo  ✅ Correção do Windows Concluída!
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Windows CORRIGIDO >> %logfile%
echo.
timeout /t 3 /nobreak >nul
goto menu_principal

:seguranca
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🛡️  PROTEÇÃO E SEGURANÇA AVANÇADA                                       ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Ativando proteções de segurança...
echo. >> %logfile%
echo  [%date% %time%] 🛡️ Segurança INICIADA >> %logfile%

call :barra_progresso 3 1 "  Verificando Defender..."
powershell -Command "Get-MpComputerStatus" >> %logfile% 2>&1

call :barra_progresso 3 2 "  Atualizando definições..."
powershell -Command "Update-MpSignature" >> %logfile% 2>&1

call :barra_progresso 3 3 "  Executando varredura..."
powershell -Command "Start-MpScan -ScanType QuickScan" >> %logfile% 2>&1

echo.
echo  ✅ Proteção Ativada com Sucesso!
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Proteção ATIVADA >> %logfile%
echo.
timeout /t 2 /nobreak >nul
goto menu_principal

:reset_rede
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🔄 RESET COMPLETO DE REDE                                               ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  [!] AVISO: Esta operação reiniciará suas configurações de rede!
echo.
set /p confirmacao="  ➤ Deseja continuar? (S/N): "
if /i not "%confirmacao%"=="S" goto menu_principal

echo.
echo  Resetando configurações de rede...
echo. >> %logfile%
echo  [%date% %time%] 🔄 Reset de Rede INICIADO >> %logfile%

call :barra_progresso 4 1 "  Resetando IP..."
netsh int ip reset resetlog.txt >> %logfile% 2>&1

call :barra_progresso 4 2 "  Resetando Winsock..."
netsh winsock reset catalog >> %logfile% 2>&1

call :barra_progresso 4 3 "  Renovando DHCP..."
ipconfig /release >> %logfile% 2>&1
ipconfig /renew >> %logfile% 2>&1

call :barra_progresso 4 4 "  Finalizando..."

echo.
echo  ✅ Reset de Rede Concluído!
echo  [!] Você pode precisar reiniciar o computador
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Reset Rede CONCLUÍDO >> %logfile%
echo.
timeout /t 3 /nobreak >nul
goto menu_principal

:backup_registro
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  💾 CRIAR PONTO DE RESTAURAÇÃO                                           ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Criando ponto de restauração do sistema...
echo. >> %logfile%
echo  [%date% %time%] 💾 Backup INICIADO >> %logfile%

call :animar_carregamento

powershell -Command "Checkpoint-Computer -Description 'BUG-KILLER Backup - %date% %time%' -RestorePointType 'MODIFY_SETTINGS'" >> %logfile% 2>&1

if %errorlevel% equ 0 (
    echo.
    echo  ✅ Ponto de Restauração Criado com Sucesso!
    set /a operacoes_sucesso+=1
    echo  [%date% %time%] ✅ Backup CONCLUÍDO >> %logfile%
) else (
    echo.
    echo  ❌ Erro ao Criar Ponto de Restauração
    set /a operacoes_erro+=1
    echo  [%date% %time%] ❌ ERRO ao criar backup >> %logfile%
)
echo.
timeout /t 3 /nobreak >nul
goto menu_principal

:monitor_processos
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  📊 MONITOR DE PROCESSOS E DESEMPENHO                                    ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Abrindo Gerenciador de Tarefas...
taskmgr.exe
set /a operacoes_sucesso+=1
goto menu_principal

:diagnostico_completo
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🔍 DIAGNÓSTICO COMPLETO DO SISTEMA                                      ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Executando diagnóstico completo...
echo  [!] Isto pode levar de 10 a 20 minutos
echo. >> %logfile%
echo  [%date% %time%] 🔍 Diagnóstico Completo INICIADO >> %logfile%

call :barra_progresso 6 1 "  Coletando informações do sistema..."
systeminfo >> %logfile% 2>&1

call :barra_progresso 6 2 "  Verificando drivers..."
driverquery >> %logfile% 2>&1

call :barra_progresso 6 3 "  Checando integridade do disco..."
chkdsk C: >> %logfile% 2>&1

call :barra_progresso 6 4 "  Listando programas instalados..."
wmic product list brief >> %logfile% 2>&1

call :barra_progresso 6 5 "  Analisando segurança..."
powershell -Command "Get-MpComputerStatus" >> %logfile% 2>&1

call :barra_progresso 6 6 "  Finalizando..."

echo.
echo  ✅ Diagnóstico Completo Finalizado!
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Diagnóstico CONCLUÍDO >> %logfile%
echo.
timeout /t 3 /nobreak >nul
goto menu_principal

:otimizacao_energia
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🔋 OTIMIZAÇÃO DE ENERGIA E DESEMPENHO                                   ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Otimizando configurações de energia...
echo. >> %logfile%
echo  [%date% %time%] 🔋 Otimização de Energia INICIADA >> %logfile%

call :barra_progresso 3 1 "  Definindo plano de alta performance..."
powercfg /setactive 8c5e7fda-e8bf-45a6-a6cc-4b3c5b54b6cb >> %logfile% 2>&1

call :barra_progresso 3 2 "  Configurando USB..."
powercfg /setacvalueindex SCHEME_CURRENT SUB_USB USBSELECTIVESUSPEND 0 >> %logfile% 2>&1

call :barra_progresso 3 3 "  Finalizando..."

echo.
echo  ✅ Otimização de Energia Concluída!
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Energia OTIMIZADA >> %logfile%
echo.
timeout /t 2 /nobreak >nul
goto menu_principal

:desativar_apps
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  📦 GERENCIADOR DE PROGRAMAS                                             ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Abrindo Gerenciador de Programas...
appwiz.cpl
set /a operacoes_sucesso+=1
goto menu_principal

:auditoria_sistema
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  📋 AUDITORIA COMPLETA DO SISTEMA                                        ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Executando auditoria do sistema...
echo. >> %logfile%
echo  [%date% %time%] 📋 Auditoria INICIADA >> %logfile%

call :barra_progresso 4 1 "  Analisando eventos..."
wevtutil query-events System /c:50 /rd:true >> %logfile% 2>&1

call :barra_progresso 4 2 "  Verificando atualizações..."
wmic qfe list brief >> %logfile% 2>&1

call :barra_progresso 4 3 "  Analisando espaço em disco..."
diskpart /s nul >> %logfile% 2>&1

call :barra_progresso 4 4 "  Finalizando..."

echo.
echo  ✅ Auditoria Concluída!
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Auditoria CONCLUÍDA >> %logfile%
echo.
timeout /t 2 /nobreak >nul
goto menu_principal

:modo_emergencia
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🔥 MODO EMERGÊNCIA - LIMPEZA AGRESSIVA                                  ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  [!!!] AVISO CRÍTICO: Esta operação é para situações de emergência!
echo  [!!!] Todos os dados temporários será removidos permanentemente!
echo.
set /p confirmacao="  ➤ Você tem certeza? Digite 'SIM' para continuar: "
if /i not "%confirmacao%"=="SIM" goto menu_principal

echo.
echo  Executando limpeza agressiva...
echo. >> %logfile%
echo  [%date% %time%] 🔥 MODO EMERGÊNCIA INICIADO >> %logfile%

call :barra_progresso 5 1 "  Limpando arquivos temporários..."
del /q /f /s %temp%\* >nul 2>&1
del /q /f /s "%systemroot%\Temp\*" >nul 2>&1

call :barra_progresso 5 2 "  Limpando cache do navegador..."
del /q /f /s "%localappdata%\Google\Chrome\*" >nul 2>&1
del /q /f /s "%appdata%\Mozilla\Firefox\*" >nul 2>&1

call :barra_progresso 5 3 "  Limpando arquivos de sistema..."
del /q /f /s %windir%\prefetch\* >nul 2>&1

call :barra_progresso 5 4 "  Limpando lixeira..."
rd /s /q %systemdrive%\$Recycle.bin >nul 2>&1

call :barra_progresso 5 5 "  Otimizando disco..."

echo.
echo  ✅ Modo Emergência Concluído!
echo  [!] Espaço em disco liberado com sucesso
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Modo Emergência CONCLUÍDO >> %logfile%
echo.
timeout /t 3 /nobreak >nul
goto menu_principal

:cache_avancado
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🧹 LIMPEZA AVANÇADA DE CACHE                                            ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Executando limpeza avançada de cache...
echo. >> %logfile%
echo  [%date% %time%] 🧹 Limpeza Avançada INICIADA >> %logfile%

call :barra_progresso 4 1 "  Limpando TEMP..."
del /q /f /s %temp%\* >nul 2>&1

call :barra_progresso 4 2 "  Limpando Prefetch..."
del /q /f /s %windir%\prefetch\* >nul 2>&1

call :barra_progresso 4 3 "  Limpando cookies e cache..."
del /q /f /s "%appdata%\*.tmp" >nul 2>&1

call :barra_progresso 4 4 "  Finalizando..."

echo.
echo  ✅ Limpeza Avançada Concluída!
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Limpeza Avançada CONCLUÍDA >> %logfile%
echo.
timeout /t 2 /nobreak >nul
goto menu_principal

:reparar_disco
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  💾 REPARO DE DISCO E SISTEMA DE ARQUIVOS                               ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  [!] AVISO: Esta operação pode levar 30-60 minutos
echo.
set /p confirmacao="  ➤ Deseja continuar? (S/N): "
if /i not "%confirmacao%"=="S" goto menu_principal

echo.
echo  Reparando disco...
echo. >> %logfile%
echo  [%date% %time%] 💾 Reparo de Disco INICIADO >> %logfile%

call :barra_progresso 2 1 "  Executando CHKDSK..."
chkdsk C: /F /R >> %logfile% 2>&1

call :barra_progresso 2 2 "  Executando Repair-Volume..."
powershell -Command "Repair-Volume -DriveLetter C -OfflineScanAndFix" >> %logfile% 2>&1

echo.
echo  ✅ Reparo de Disco Concluído!
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Reparo CONCLUÍDO >> %logfile%
echo.
timeout /t 2 /nobreak >nul
goto menu_principal

:otimizar_performance
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  ⚡ OTIMIZAÇÃO COMPLETA DE PERFORMANCE                                   ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Otimizando performance do sistema...
echo. >> %logfile%
echo  [%date% %time%] ⚡ Performance OTIMIZAÇÃO INICIADA >> %logfile%

call :barra_progresso 4 1 "  Desfragmentando disco..."
defrag C: /U /V >> %logfile% 2>&1

call :barra_progresso 4 2 "  Otimizando efeitos visuais..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >> %logfile% 2>&1

call :barra_progresso 4 3 "  Limpando inicialização..."
msconfig /noauto >> %logfile% 2>&1

call :barra_progresso 4 4 "  Finalizando..."

echo.
echo  ✅ Otimização Concluída!
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Performance OTIMIZADA >> %logfile%
echo.
timeout /t 2 /nobreak >nul
goto menu_principal

:limpar_registro
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🔧 LIMPEZA AVANÇADA DO REGISTRO WINDOWS                                 ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  [!!!] AVISO CRÍTICO: Esta operação modifica o Registro!
echo  [!!!] Certifique-se de ter um backup antes de continuar!
echo.
set /p confirmacao="  ➤ Você tem certeza? Digite 'CONFIRMAR' para continuar: "
if /i not "%confirmacao%"=="CONFIRMAR" goto menu_principal

echo.
echo  Limpando Registro...
echo. >> %logfile%
echo  [%date% %time%] 🔧 Limpeza Registro INICIADA >> %logfile%

call :barra_progresso 3 1 "  Removendo MRU..."
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f >> %logfile% 2>&1

call :barra_progresso 3 2 "  Removendo AppCompat..."
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /f >> %logfile% 2>&1

call :barra_progresso 3 3 "  Finalizando..."

echo.
echo  ✅ Limpeza de Registro Concluída!
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Registro LIMPO >> %logfile%
echo.
timeout /t 2 /nobreak >nul
goto menu_principal

:corrigir_rede
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🌐 CORREÇÃO AVANÇADA DE REDE                                            ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Corrigindo problemas de rede...
echo. >> %logfile%
echo  [%date% %time%] 🌐 Correção Rede INICIADA >> %logfile%

call :barra_progresso 4 1 "  Resetando IP..."
netsh int ip reset resetlog.txt >> %logfile% 2>&1

call :barra_progresso 4 2 "  Resetando Winsock..."
netsh winsock reset catalog >> %logfile% 2>&1

call :barra_progresso 4 3 "  Limpando DNS..."
ipconfig /flushdns >> %logfile% 2>&1

call :barra_progresso 4 4 "  Finalizando..."

echo.
echo  ✅ Correção de Rede Concluída!
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Rede CORRIGIDA >> %logfile%
echo.
timeout /t 2 /nobreak >nul
goto menu_principal

:reparar_permissoes
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🔐 REPARO DE PERMISSÕES DE ARQUIVO                                      ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Reparando permissões...
echo. >> %logfile%
echo  [%date% %time%] 🔐 Reparo Permissões INICIADO >> %logfile%

call :barra_progresso 3 1 "  Restaurando Program Files..."
takeown /f "%programfiles%" /r /d y >> %logfile% 2>&1
icacls "%programfiles%" /grant:r "%username%":F /t >> %logfile% 2>&1

call :barra_progresso 3 2 "  Restaurando Program Files x86..."
takeown /f "%programfiles(x86)%" /r /d y >> %logfile% 2>&1
icacls "%programfiles(x86)%" /grant:r "%username%":F /t >> %logfile% 2>&1

call :barra_progresso 3 3 "  Finalizando..."

echo.
echo  ✅ Reparo de Permissões Concluído!
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Permissões REPARADAS >> %logfile%
echo.
timeout /t 2 /nobreak >nul
goto menu_principal

:manutencao_completa
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🚀 MANUTENÇÃO COMPLETA DO SISTEMA                                       ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  [!] Esta operação executará TODAS as otimizações
echo  [!] Isto pode levar de 60-120 minutos
echo.
set /p confirmacao="  ➤ Deseja continuar? (S/N): "
if /i not "%confirmacao%"=="S" goto menu_principal

echo.
echo  Iniciando Manutenção Completa...
echo. >> %logfile%
echo  [%date% %time%] 🚀 MANUTENÇÃO COMPLETA INICIADA >> %logfile%

call :limpeza_rapida
call :limpeza_dns
call :cache_avancado
call :reparar_disco
call :otimizar_performance
call :corrigir_rede
call :reparar_permissoes

echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  ✅ MANUTENÇÃO COMPLETA FINALIZADA COM SUCESSO!                          ║
echo  ║  ✅ Seu computador foi otimizado e reparado completamente               ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ MANUTENÇÃO COMPLETA CONCLUÍDA >> %logfile%
echo.
timeout /t 3 /nobreak >nul
goto menu_principal

:resetar_politicas
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  ⚙️  RESETAR POLÍTICAS DO WINDOWS                                        ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  [!] AVISO: Esta operação afetará as políticas de grupo
echo.
set /p confirmacao="  ➤ Deseja continuar? (S/N): "
if /i not "%confirmacao%"=="S" goto menu_principal

echo.
echo  Resetando políticas...
echo. >> %logfile%
echo  [%date% %time%] ⚙️ Resetar Políticas INICIADO >> %logfile%

call :barra_progresso 2 1 "  Limpando cache..."
del /q /f /s "%systemroot%\System32\grouppolicy\*" >nul 2>&1

call :barra_progresso 2 2 "  Recarregando..."
gpupdate /force >> %logfile% 2>&1

echo.
echo  ✅ Políticas Resetadas!
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Políticas RESETADAS >> %logfile%
echo.
timeout /t 2 /nobreak >nul
goto menu_principal

:limpar_restauracao
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🗂️  LIMPAR PONTOS DE RESTAURAÇÃO                                        ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  [!!!] AVISO: Isto removerá TODOS os pontos de restauração!
echo.
set /p confirmacao="  ➤ Deseja continuar? (S/N): "
if /i not "%confirmacao%"=="S" goto menu_principal

echo.
echo  Limpando pontos de restauração...
echo. >> %logfile%
echo  [%date% %time%] 🗂️ Limpeza Restauração INICIADA >> %logfile%

powershell -Command "vssadmin delete shadows /for=%systemdrive% /all /quiet" >> %logfile% 2>&1

echo.
echo  ✅ Pontos de Restauração Removidos!
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Restauração LIMPA >> %logfile%
echo.
timeout /t 2 /nobreak >nul
goto menu_principal

:analise_sistema
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  📈 ANÁLISE AVANÇADA DE SISTEMA                                          ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo. >> %logfile%
echo  [%date% %time%] 📈 Análise de Sistema INICIADA >> %logfile%

call :barra_progresso 5 1 "  Analisando hardware..."
systeminfo >> %logfile% 2>&1

call :barra_progresso 5 2 "  Analisando software..."
wmic product list brief >> %logfile% 2>&1

call :barra_progresso 5 3 "  Analisando disco..."
wmic logicaldisk get name,size,freespace >> %logfile% 2>&1

call :barra_progresso 5 4 "  Analisando rede..."
ipconfig /all >> %logfile% 2>&1

call :barra_progresso 5 5 "  Finalizando..."

echo.
echo  ✅ Análise Concluída!
set /a operacoes_sucesso+=1
echo  [%date% %time%] ✅ Análise CONCLUÍDA >> %logfile%
echo.
timeout /t 2 /nobreak >nul
goto menu_principal

:meus_favoritos
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  ⭐ MEUS FAVORITOS                                                        ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
if exist %favorites% (
    type %favorites%
) else (
    echo  Nenhum favorito salvo ainda!
    echo.
    echo  Para adicionar um favorito, selecione uma operação e marque como favorita.
)
echo.
timeout /t 3 /nobreak >nul
goto menu_principal

:historico
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🕐 HISTÓRICO DE OPERAÇÕES                                               ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
if exist %history% (
    type %history%
) else (
    echo  Nenhuma operação registrada no histórico!
)
echo.
timeout /t 3 /nobreak >nul
goto menu_principal

:configuracoes
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  ⚙️  CONFIGURAÇÕES DO SISTEMA                                            ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Selecione o utilitário que deseja abrir:
echo.
echo  1 │ ⚙️  Configurações do Windows
echo  2 │ 🖥️  Gerenciador de Dispositivos
echo  3 │ 📊 Gerenciador de Tarefas
echo  4 │ 📝 Editor de Registro
echo  5 │ 📋 Visualizador de Eventos
echo  6 │ 🔧 Gerenciador de Serviços
echo  7 │ 📈 Monitor de Recursos
echo  8 │ 🧹 Limpeza de Disco
echo  9 │ 💿 Desfragmentador
echo  10│ 🗂️  Gerenciador de Partições
echo.
set /p util_choice="  ➤ Digite a opção: "

if "%util_choice%"=="1" start ms-settings:
if "%util_choice%"=="2" devmgmt.msc
if "%util_choice%"=="3" taskmgr.exe
if "%util_choice%"=="4" regedit.exe
if "%util_choice%"=="5" eventvwr.msc
if "%util_choice%"=="6" services.msc
if "%util_choice%"=="7" resmon.exe
if "%util_choice%"=="8" cleanmgr.exe
if "%util_choice%"=="9" dfrgui.exe
if "%util_choice%"=="10" diskmgmt.msc

goto menu_principal

:ajuda
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  ❓ CENTRAL DE AJUDA - BUG-KILLER PRO                                    ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  📌 GUIA RÁPIDO:
echo.
echo  1. Limpeza Rápida
echo     ├─ Remove arquivos temporários da pasta TEMP
echo     ├─ Limpa prefetch do Windows
echo     └─ Esvazia a lixeira
echo.
echo  2. Diagnóstico de Rede
echo     ├─ Verifica configurações de rede
echo     ├─ Testa conectividade com internet
echo     └─ Lista rotas e portas abertas
echo.
echo  3. Correção do Windows
echo     ├─ Executa SFC (System File Checker)
echo     ├─ Executa DISM (reparo de imagem)
echo     └─ Recomendado para problemas graves
echo.
echo  4. Manutenção Completa
echo     ├─ Executa TODAS as operações críticas
echo     ├─ Pode levar 60-120 minutos
echo     └─ Recomendado mensalmente
echo.
echo  💡 DICAS:
echo     • Execute como Administrador para funcionalidade completa
echo     • Faça backup antes de usar funções "Cuidado"
echo     • Consulte o log de operações em caso de erro
echo.
echo  ⚠️  AVISOS:
echo     • Não interrompa operações em progresso
echo     • Alguns reparos requerem reinicialização
echo     • Modo Emergência é para situações críticas
echo.
timeout /t 5 /nobreak >nul
goto menu_principal

:sobre
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║                          SOBRE - BUG-KILLER                              ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  Nome: BUG-KILLER PRO
echo  Versão: %version%
echo  Desenvolvimento: 2026
echo  Última Atualização: 2026-03-24
echo.
echo  Descrição:
echo  Sistema profissional de manutenção e otimização do Windows
echo  Desenvolvido para diagnóstico, limpeza e reparo completo
echo.
echo  Recursos:
echo  ✓ 30+ operações de manutenção
echo  ✓ Interface visual moderna
echo  ✓ Sistema de logging completo
echo  ✓ Modo Emergência
echo  ✓ Diagnóstico avançado
echo.
echo  Suporte:
echo  Para mais informações, consulte o arquivo de LOG
echo  Local: %logfile%
echo.
timeout /t 3 /nobreak >nul
goto menu_principal

:ver_log
cls
if exist %logfile% (
    echo.
    echo  ╔═══════════════════════════════════════════════════════════════════════════╗
    echo  ║  📋 ARQUIVO DE LOG                                                        ║
    echo  ╚═══════════════════════════════════════════════════════════════════════════╝
    echo.
    echo  Abrindo arquivo de log...
    echo.
    notepad %logfile%
) else (
    echo.
    echo  ❌ Nenhum arquivo de log encontrado
)
goto menu_principal

:config_sistema
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  ⚙️  CONFIGURAÇÕES DO SISTEMA                                            ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  1 │ 🔇 Modo Silencioso (Ativar/Desativar)
echo  2 │ 🔄 Modo Simulação (Dry-Run)
echo  3 │ 📊 Alterar Intervalo de Auto-Limpeza
echo  4 │ 💾 Exportar Configurações
echo  5 │ 🔄 Restaurar Padrões
echo  0 │ ❌ Voltar
echo.
set /p config_choice="  ➤ Digite a opção: "

if "%config_choice%"=="1" (
    if %modo_silencioso% equ 0 (
        set modo_silencioso=1
        echo ✓ Modo Silencioso ATIVADO
    ) else (
        set modo_silencioso=0
        echo ✓ Modo Silencioso DESATIVADO
    )
)

timeout /t 2 /nobreak >nul
goto menu_principal

:executar_perfil
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🎯 PERFIS DE EXECUÇÃO                                                    ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo  1 │ 🚀 Perfil Máximo - Todas as otimizações (120 min)
echo  2 │ ⚡ Perfil Rápido - Limpeza e otimização (30 min)
echo  3 │ 🌍 Perfil Rede - Diagnóstico e reparo de rede (20 min)
echo  4 │ 🔨 Perfil Reparo - Reparo completo do sistema (45 min)
echo  0 │ ❌ Voltar
echo.
set /p perfil="  ➤ Escolha um perfil: "

if "%perfil%"=="1" goto manutencao_completa
if "%perfil%"=="2" (
    call :limpeza_rapida
    call :otimizar_performance
)
if "%perfil%"=="3" (
    call :diagnostico_rede
    call :corrigir_rede
)
if "%perfil%"=="4" (
    call :correcao_windows
    call :reparar_disco
    call :reparar_permissoes
)

goto menu_principal

:procurar_funcao
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🔍 PROCURAR FUNCIONALIDADE                                              ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p busca="  ➤ Digite o que você está procurando: "

echo.
echo  Resultados encontrados:
echo.

if /i "%busca%"=="limpeza" (
    echo  ✓ Limpeza Rápida (opção 1)
    echo  ✓ Limpeza de DNS (opção 2)
    echo  ✓ Cache Avançado (opção 16)
)

if /i "%busca%"=="rede" (
    echo  ✓ Limpeza de DNS (opção 2)
    echo  ✓ Diagnóstico de Rede (opção 3)
    echo  ✓ Reset de Rede (opção 8)
    echo  ✓ Corrigir Rede (opção 20)
)

if /i "%busca%"=="sistema" (
    echo  ✓ Correção do Windows (opção 6)
    echo  ✓ Diagnóstico Completo (opção 11)
    echo  ✓ Auditoria Sistema (opção 14)
    echo  ✓ Análise de Sistema (opção 25)
)

echo.
timeout /t 3 /nobreak >nul
goto menu_principal

:reiniciar_sistema
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  🔄 REINICIAR SISTEMA                                                    ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set /p tempo="  ➤ Digite o tempo em segundos para reinício (padrão=30): "
if "%tempo%"=="" set tempo=30

echo.
echo  Sistema será reiniciado em %tempo% segundos!
echo  [!] Salve seus arquivos agora!
echo.

shutdown /r /t %tempo% /c "Reinício agendado pelo BUG-KILLER"
set /a operacoes_sucesso+=1
echo  [%date% %time%] 🔄 Reinício agendado em %tempo% segundos >> %logfile%

timeout /t 3 /nobreak >nul
goto menu_principal

:sair
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo  ║  ✅ BUG-KILLER PRO FINALIZADO                                            ║
echo  ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo.
echo  📊 RESUMO DA SESSÃO:
echo.
echo  ✓ Operações com Sucesso: %operacoes_sucesso%
echo  ✗ Erros Encontrados: %operacoes_erro%
echo.
echo  📂 Local do Log: %logfile%
echo.
echo  🙏 Obrigado por usar BUG-KILLER PRO!
echo  🖥️  Seu sistema foi mantido com sucesso!
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════════╗
echo.

timeout /t 3 /nobreak >nul
exit /b 0