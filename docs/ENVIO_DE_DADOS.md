# Envio de dados para o Power BI

Os arquivos passam do Linux para o Windows pela pasta **`shared/`** deste projeto. Ela é a mesma pasta nos dois lados:

| Onde | Caminho |
|---|---|
| Linux | `~/powerbi-docker/shared/` |
| Windows / Power BI (**recomendado**) | `\\host.lan\Data\` |
| Windows, só com a janela aberta pelo `make powerbi` | `\\tsclient\shared\` |

O que você coloca em `shared/` aparece no Windows na hora, sem reiniciar nada.

## 1. Enviar os arquivos

```bash
cd ~/powerbi-docker
./enviar.sh ~/Downloads/"Fonte de Dados_MC.zip" ~/Downloads/Telas_MC.zip
```

- **`.zip`** → é extraído dentro de `shared/` (mantém as pastas do zip).
- **Outros arquivos** (`.xlsx`, `.csv`, `.png`, pastas...) → são copiados para `shared/`.
- Se já existir um arquivo com o mesmo nome, ele é **substituído**. É assim que se atualiza uma planilha.

Também dá para copiar direto: `cp planilha.xlsx ~/powerbi-docker/shared/`, ou arrastar pelo gerenciador de arquivos.

Para ver o que já foi enviado:

```bash
make dados
```

## 2. Usar no Power BI

1. Abra o Power BI: `make powerbi`
2. **Página Inicial → Obter dados → Pasta de trabalho do Excel** (ou Texto/CSV, etc.)
3. Na caixa de abrir arquivo, digite na barra de endereço:
   ```
   \\host.lan\Data
   ```
   e navegue até a planilha (ex.: `\\host.lan\Data\Fonte de Dados\Vendas_.xlsx`).
4. Escolha as tabelas/abas e clique em **Transformar dados** ou **Carregar**.

Imagens (fundos de tela, ícones, SVG) entram pelo **Formatar → Tela de fundo / Imagem** e usam o mesmo caminho `\\host.lan\Data\Telas\...`.

> **Por que `\\host.lan\Data` e não `\\tsclient\shared`?** O `\\tsclient` só existe enquanto a janela RDP está aberta. Se o relatório apontar para ele, o **Atualizar** falha quando você abrir o Windows por outro caminho (ex.: `make tela`). O `\\host.lan\Data` está sempre disponível.

## 3. Atualizar os dados

1. Envie a nova versão com **o mesmo nome e na mesma pasta**: `./enviar.sh novo.zip` ou `cp`.
2. No Power BI: **Página Inicial → Atualizar**.

Se mudar o nome ou a pasta do arquivo, ajuste em **Transformar dados → Configurações da fonte de dados → Alterar fonte**.

## 4. Salvar o relatório (.pbix)

Salve o `.pbix` em `\\host.lan\Data\` para ele ficar também no Linux (`shared/`) e entrar no seu backup. Se salvar em `C:\Users\aluno\Documents`, ele fica só dentro do disco da VM.

## Dados atuais

| Pasta | Conteúdo | Origem |
|---|---|---|
| `Fonte de Dados/` | `Colaboradores.xlsx`, `DadosEmpresa.xlsx`, `Vendas_.xlsx` | `Fonte de Dados_MC.zip` |
| `Telas/` | `0.png`, `2.png`–`7.png`, `8.SVG`, `Modelo_Vendas.SVG` | `Telas_MC.zip` |

## Problemas comuns

| Sintoma | Solução |
|---|---|
| `\\host.lan\Data` não abre | Confirme que o Windows está ligado (`make status`). Teste no Explorador de Arquivos pelo `make tela`. |
| Arquivo não aparece | Rode `make dados` para ver se ele está mesmo em `shared/`. No Windows, aperte F5. |
| "Arquivo em uso" ao atualizar | Feche a planilha no Excel/LibreOffice antes de substituir ou de atualizar no Power BI. |
| Atualizar falha com "caminho não encontrado" | O relatório aponta para `\\tsclient\...`. Troque para `\\host.lan\Data\...` em *Configurações da fonte de dados*. |

## Git

O conteúdo de `shared/` **não** é versionado (`.gitignore`), porque planilhas e relatórios podem ter dados sensíveis. Só a estrutura do projeto vai para o repositório.
