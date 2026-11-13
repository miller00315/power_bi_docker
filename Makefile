RDP_USER := aluno
RDP_PASS := aluno
PBI_EXE  := C:\Program Files\Microsoft Power BI Desktop\bin\PBIDesktop.exe
RDP_OPTS := /v:127.0.0.1:3389 /u:$(RDP_USER) /p:$(RDP_PASS) /cert-ignore

.DEFAULT_GOAL := powerbi
.PHONY: powerbi up stop status logs tela clean help

help: ## Lista os comandos
	@grep -E '^[a-z]+:.*##' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  make %-8s %s\n", $$1, $$2}'

powerbi: up ## Liga o Windows (se preciso) e abre só a janela do Power BI
	@command -v xfreerdp >/dev/null || { echo "Instale o FreeRDP: sudo apt install freerdp2-x11"; exit 1; }
	@echo "Aguardando o Windows ficar pronto (na 1a vez a instalação leva ~30-60 min; acompanhe com 'make tela')..."
	@until xfreerdp $(RDP_OPTS) /auth-only >/dev/null 2>&1; do sleep 10; done
	@echo "Abrindo Power BI..."
	@xfreerdp $(RDP_OPTS) /app:"$(PBI_EXE)" /drive:shared,$(CURDIR)/shared +clipboard >/dev/null 2>&1 &

up: ## Liga o contêiner do Windows
	@docker compose up -d

stop: ## Desliga o Windows (os dados ficam salvos)
	@docker compose stop

status: ## Mostra se está ligado
	@docker compose ps

logs: ## Acompanha os logs do contêiner
	@docker logs -f powerbi-windows

tela: up ## Abre a área de trabalho do Windows no navegador
	@xdg-open http://localhost:8006 >/dev/null 2>&1 &

clean: ## APAGA o Windows instalado (pede confirmação)
	@read -p "Apagar o disco do Windows em ./storage? [s/N] " r && [ "$$r" = s ] && docker compose down && rm -rf storage/* || echo "Cancelado."
