# DIP-Image-Sample

Este repositório contém imagens de exemplo para introdução ao processamento de imagens no Matlab, bem como Jupyter Notebooks com foco em aprendizado de máquina e análise de dados (ex: `3_support_vector_machines_for_regression.ipynb`).

## Estrutura do Projeto
* **Imagens de Exemplo:** Focadas no processamento prático de imagens em Matlab.
* **Jupyter Notebooks:** Exemplos práticos em Python para aprendizado de máquina (Machine Learning), como o uso de Máquinas de Vetores de Suporte (SVM).

## Como executar os Notebooks (Python)

Para garantir que os notebooks funcionem corretamente sem afetar o seu sistema operacional, é altamente recomendável criar um ambiente virtual (Virtual Environment). Siga o passo a passo abaixo:

### 1. Criar o Ambiente Virtual
No terminal, navegue até a raiz deste repositório e execute o seguinte comando para criar a pasta `venv` que conterá o ambiente:
```bash
python3 -m venv venv
```

### 2. Ativar o Ambiente Virtual
Antes de instalar qualquer pacote, você precisa ativar o ambiente criado:
* **No Linux/macOS:**
  ```bash
  source venv/bin/activate
  ```
* **No Windows (Prompt de Comando):**
  ```cmd
  venv\Scripts\activate.bat
  ```

### 3. Instalar as Dependências
Com o ambiente ativado (você verá `(venv)` no início da linha do terminal), instale as bibliotecas necessárias que estão no arquivo `requirements.txt`:
```bash
pip install -r requirements.txt
```

### 4. Abrir os Notebooks
Agora basta iniciar o Jupyter Notebook com o comando:
```bash
jupyter notebook
```
Isso abrirá uma janela no seu navegador padrão onde você poderá clicar no arquivo `.ipynb` e executar suas células livremente.
