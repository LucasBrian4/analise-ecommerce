import pandas as pd

# ================================================
# LIMPEZA E TRATAMENTO DE DADOS - E-COMMERCE
# Dataset: E-Commerce Sales 2024-2025 (Kaggle)
# ================================================

# 1. CARREGAMENTO DOS DADOS
df = pd.read_csv('Ecommerce_Sales_Data_2024_2025.csv')

print("=== INFORMAÇÕES INICIAIS ===")
print(f"Total de registros: {len(df)}")
print(f"Total de colunas: {len(df.columns)}")
print(f"\nColunas originais:\n{list(df.columns)}")

# 2. VERIFICAÇÃO DE QUALIDADE
print("\n=== VERIFICAÇÃO DE QUALIDADE ===")
print(f"Valores nulos:\n{df.isnull().sum()}")
print(f"\nRegistros duplicados: {df.duplicated().sum()}")

# 3. RENOMEAÇÃO DAS COLUNAS PARA PORTUGUÊS
df.rename(columns={
    'Order ID'      : 'id_pedido',
    'Order Date'    : 'data_pedido',
    'Customer Name' : 'nome_cliente',
    'Region'        : 'regiao',
    'City'          : 'cidade',
    'Category'      : 'categoria',
    'Sub-Category'  : 'subcategoria',
    'Product Name'  : 'nome_produto',
    'Quantity'      : 'quantidade',
    'Unit Price'    : 'preco_unitario',
    'Discount'      : 'desconto_pct',
    'Sales'         : 'valor_venda',
    'Profit'        : 'lucro',
    'Payment Mode'  : 'forma_pagamento'
}, inplace=True)

# 4. CONVERSÃO DE TIPOS
df['data_pedido'] = pd.to_datetime(df['data_pedido'])

# 5. TRADUÇÃO DE VALORES
df['regiao'] = df['regiao'].replace({
    'North' : 'Norte',
    'South' : 'Sul',
    'East'  : 'Leste',
    'West'  : 'Oeste'
})

df['forma_pagamento'] = df['forma_pagamento'].replace({
    'Debit Card'  : 'Cartão de Débito',
    'Credit Card' : 'Cartão de Crédito',
    'Net Banking' : 'Transferência Bancária',
    'COD'         : 'Pagamento na Entrega',
    'UPI'         : 'UPI'
})

# 6. CRIAÇÃO DE COLUNAS AUXILIARES
df['ano']         = df['data_pedido'].dt.year
df['mes']         = df['data_pedido'].dt.month
df['nome_mes']    = df['data_pedido'].dt.strftime('%B').str.capitalize()
df['margem_pct']  = (df['lucro'] / df['valor_venda'] * 100).round(2)

# 7. VERIFICAÇÃO FINAL
print("\n=== DADOS TRATADOS ===")
print(f"Colunas finais:\n{list(df.columns)}")
print(f"\nPrimeiros registros:")
print(df.head(3).to_string())

# 8. EXPORTAÇÃO
df.to_csv('/mnt/user-data/outputs/ecommerce_tratado.csv', index=False, encoding='utf-8-sig')
print("\n✅ Arquivo 'ecommerce_tratado.csv' exportado com sucesso!")
