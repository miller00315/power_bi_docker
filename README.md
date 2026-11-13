# Power BI Desktop no Linux (Docker)

Roda o **Power BI Desktop** no Linux com uma VM Windows 11 enxuta (tiny11) dentro de um contêiner [dockurr/windows](https://github.com/dockur/windows). Pelo FreeRDP em modo RemoteApp, só a janela do Power BI aparece na sua área de trabalho, como se fosse um app nativo.

## Requisitos

- Linux com virtualização habilitada (`/dev/kvm`)
- Docker + Docker Compose
- FreeRDP: `sudo apt install freerdp2-x11`
- ~40 GB livres em disco, 4 GB de RAM para a VM

## Uso

```bash
make            # = make powerbi: liga o Windows (se preciso) e abre o Power BI
make tela       # área de trabalho completa do Windows no navegador (http://localhost:8006)
make stop       # desliga o Windows (os dados ficam salvos)
make status     # mostra se o contêiner está ligado
make logs       # acompanha os logs
make clean      # APAGA o Windows instalado (pede confirmação)
make dados      # lista os arquivos enviados ao Windows
make help       # lista os comandos
```

Na **primeira execução** o Windows é baixado e instalado automaticamente (~30–60 min). Ao final, o `oem/install.bat` libera o RemoteApp e instala o Power BI Desktop. Acompanhe com `make tela`.

## Enviar dados (planilhas, imagens, zips)

```bash
./enviar.sh ~/Downloads/"Fonte de Dados_MC.zip" ~/Downloads/planilha.xlsx
```

No Power BI, abra os arquivos em **`\\host.lan\Data\`**. Veja o passo a passo completo em [docs/ENVIO_DE_DADOS.md](docs/ENVIO_DE_DADOS.md).

## Acesso RDP (área de trabalho completa)

Endereço `127.0.0.1:3389`, usuário/senha `aluno` / `aluno`:

```bash
xfreerdp /v:127.0.0.1:3389 /u:aluno /p:aluno /cert-ignore /dynamic-resolution +clipboard
```

## Estrutura

| Caminho | Descrição |
|---|---|
| `compose.yml` | Configuração da VM (versão, idioma pt-BR, RAM, CPUs, disco, portas) |
| `Makefile` | Atalhos para ligar, abrir o Power BI e desligar |
| `oem/install.bat` | Roda ao fim da instalação do Windows: habilita RemoteApp e instala o Power BI |
| `enviar.sh` | Envia arquivos/zips para a pasta compartilhada |
| `docs/ENVIO_DE_DADOS.md` | Guia de envio e uso de dados no Power BI |
| `shared/` | Pasta compartilhada com o Windows (`\\host.lan\Data`), não versionada |
| `storage/` | Disco da VM (não versionado) |

## Notas

- As portas 8006 (tela web) e 3389 (RDP) ficam expostas só em `127.0.0.1`.
- O usuário/senha padrão do Windows é `aluno` / `aluno` (definido em `compose.yml` e no `Makefile`). Troque se for expor a máquina.
- Para mudar RAM/CPU, edite `RAM_SIZE` e `CPU_CORES` no `compose.yml`.
